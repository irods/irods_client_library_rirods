#' Save Files and Objects in iRODS
#'
#' Store an object or file into iRODS. [iput()] should be used to transfer
#' a file from the local storage to iRODS; [isaveRDS()] saves an R object from
#' the current environment in iRODS in RDS format (see [saveRDS()]).
#'
#' @param local_path Local path of file to be sent to iRODS.
#' @param x R object to save in iRODS.
#' @param logical_path Destination path in iRODS.
#'    By default, the basename of `local_path` is used and the file is
#'    stored in the current working directory (see [ipwd()]).
#' @param offset Offset in bytes into the data object. Defaults to 0.
#' @param count Maximum number of bytes to write. Defaults to 2000.
#' @param truncate Whether to truncate the object when opening it. Defaults to
#'  `TRUE`.
#' @param verbose Whether to print information about the HTTP request and
#'  response. Defaults to `FALSE`.
#' @param overwrite Whether the file in iRODS should be overwritten if it
#'  exists. Defaults to `FALSE`.
#'
#' @return (Invisibly) the HTTP response.
#' @seealso
#'  [iget()] for obtaining files,
#'  [ireadRDS()] for obtaining R objects from iRODS,
#'  [saveRDS()] for an R equivalent.
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#'
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' # use_irods_demo()
#'
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authenticate
#' iauth("rods", "rods")
#'
#' # save the iris dataset as csv and send the file to iRODS
#' write.csv(iris, "iris.csv")
#' iput("iris.csv")
#'
#' # save with a different name
#' iput("iris.csv", "iris_in_irods.csv")
#' ils()
#'
#' # send an R object to iRODS in RDS format
#' isaveRDS(iris, "iris_in_rds.rds")
#'
#' # delete objects in iRODS
#' irm("iris_in_irods.csv", force = TRUE)
#' irm("iris_in_rds.rds", force = TRUE)
#' irm("iris.csv", force = TRUE)
#'
#' # delete locally
#' unlink("iris.csv")
#'
#' # remove iRODS project file
#' unlink(paste0(basename(getwd()), ".irods"))
iput <- function(
    local_path,
    logical_path = basename(local_path),
    offset = 0,
    count = 2000L,
    truncate = "true",
    verbose = FALSE,
    overwrite = FALSE
  ) {

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # check if iRODS object already exists and whether it should be overwritten
  stop_irods_overwrite(overwrite, logical_path)

  # check if local file exists
  if (!(is.character(local_path) && file.exists(local_path))) {
    stop("Local file [", basename(local_path) , "] does not exist.",
         call. = FALSE)
  }

  # handle file to iRODS conversion
  out <-local_to_irods(
    object = local_path,
    logical_path = logical_path,
    offset = offset,
    count = count,
    truncate = truncate,
    verbose = verbose
  )

  invisible(out[[1]])
}

#' @rdname iput
#' @export
isaveRDS <- function(
    x,
    logical_path,
    offset = 0,
    count = 2000L,
    truncate = "true",
    verbose = FALSE,
    overwrite = FALSE
) {

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # check if iRODS object already exists and whether it should be overwritten
  stop_irods_overwrite(overwrite, logical_path)

  # object name
  name <- deparse(substitute(x))

  # check if the R object exists in the calling environment
  if (!exists(name, envir = parent.frame())) {
    stop("Local object [", name ,"] does not exist.", call. = FALSE)
  }

  # handle R object to iRODS conversion
  out <- local_to_irods(
    object = x,
    logical_path = logical_path,
    offset = offset,
    count = count,
    truncate = truncate,
    verbose = verbose
  )

  invisible(out[[1]])
}

# vectorised object to iRODS conversion (object needs to be a raw object)
local_to_irods <- function(object, logical_path, offset, count, truncate,
                           verbose) {

  # create placeholder object on iRODS with `truncate` is true in all cases
  args <- list(
      `logical-path` = logical_path,
      offset = offset,
      count = count
  )
  irods_rest_call("stream", "PUT", args, verbose)

  if (is.character(object) && file.exists(object)) {
    # make a connection to read the file as raw bytes
    con <- file(object, "rb", raw = TRUE)
    # close connection on exit
    on.exit(close(con))
    # chunk object when necessary, this is based on the REST API byte number
    # this is the parameter `count` of the stream end-point
    if (file.size(object) > count){
      # in case of files we chunk on the fly during the loop
      truncate <- "false" # needs to be false to allow larger files
      # chunk file (we will just pass along the connection but add also the
      # offset and count sizes)
      x <- chunk_file(object, count)
      x[[1]] <- list(con)
    } else {
      x <- list(object = list(con), offset = 0, count = count)
    }
  } else {
    # serialize R object
    # `serialize("<object>", collection = NULL)` returns a raw vector
    raw_object <- serialize(object, connection = NULL)
    if (length(raw_object) > count) { # length is number of bytes
      # in case of R objects we chunk before the loop
      truncate <- "false" # needs to be false for larger objects
      x <- chunk_object(raw_object, count)
    } else {
      x <- list(object = list(raw_object), offset = 0, count = count)
    }
  }

  # vectorised call of file which enables chunked object transfer in case of
  # larger object size than `count` bytes
  Map(
    function(x, y, z) {
      local_to_irods_(
        object = x,
        logical_path = logical_path,
        offset = y,
        count = z,
        truncate = truncate,
        verbose = verbose
      )
    },
    x[[1]],
    x[[2]],
    x[[3]]
  )

}

#' Object to iRODS conversion
#' @noRd
local_to_irods_ <- function(
    object,
    logical_path,
    offset,
    count,
    truncate,
    verbose
  ) {

  # if connection then only here read the data chunk
  if (inherits(object, "connection")) {
    object <- readBin(object, raw(), n = count, endian = "swap")
  }

  # flags to curl call
  args <- list(
    `logical-path` = logical_path,
    offset = offset,
    count = count,
    truncate = truncate
  )

  # http call
  irods_rest_call("stream", "PUT", args, verbose, object)
}

#' Retrieve File or Object from iRODS
#'
#' Transfer a file from iRODS to the local storage with [iget()] or
#' read an R object from an RDS file in iRODS with [ireadRDS()]
#' (see [readRDS()]).
#'
#' @param logical_path Source path in iRODS.
#' @param local_path Destination path in local storage. By default,
#'   the basename of the logical path; the file will be stored in the current
#'   directory (see [getwd()]).
#' @param offset Offset in bytes into the data object. Defaults to 0.
#' @param count Maximum number of bytes to write. Defaults to 2000.
#' @param verbose Whether information should be printed about the HTTP request
#'  and response. Defaults to `FALSE`.
#' @param overwrite Whether the local file should be overwritten if it exists.
#'    Defaults to `FALSE`.
#'
#' @return The R object in case of `ireadRDS()`, invisibly `NULL` in case of
#'  `iget()`.
#' @seealso
#'  [iput()] for sending files,
#'  [isaveRDS()] for sending R objects to iRODS,
#'  [readRDS()] for an R equivalent.
#'
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#'
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' # use_irods_demo()
#'
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authenticate
#' iauth("rods", "rods")
#'
#' # save the iris dataset as csv and send the file to iRODS
#' write.csv(iris, "iris.csv")
#' iput("iris.csv")
#'
#' # bring the file back with a different name
#' iget("iris.csv", "newer_iris.csv")
#' file.exists("newer_iris.csv") # check that it has been transferred
#'
#' # send an R object to iRODS in RDS format
#' isaveRDS(iris, "irids_in_rds.rds")
#'
#' # read it back
#' iris_again <- ireadRDS("irids_in_rds.rds")
#' iris_again
#'
#' # delete objects in iRODS
#' irm("irids_in_rds.rds", force = TRUE)
#' irm("iris.csv", force = TRUE)
#'
#' # delete locally
#' unlink("iris.csv")
#' unlink("newer_iris.csv")
#'
#' # remove iRODS project file
#' unlink(paste0(basename(getwd()), ".irods"))
#'
iget <- function(
    logical_path,
    local_path = basename(logical_path),
    offset = 0,
    count = 2000L,
    verbose = FALSE,
    overwrite = FALSE
  ) {

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # check for local file
  stop_local_overwrite(overwrite, local_path)

  # close connection on exit
  on.exit(close(con))

  # write to file
  if (file.exists(local_path))
    unlink(local_path)
  con <- file(local_path, "ab", raw = TRUE)

  # handle iRODS to local file conversion
  resp <- irods_to_local(
    logical_path = logical_path,
    offset = offset,
    count = count,
    verbose = verbose,
    local_path = con
  )

  # return
  invisible(NULL)
}

#' @rdname iget
#'
#' @export
ireadRDS <- function(
    logical_path,
    offset = 0,
    count = 2000L,
    verbose = FALSE,
    overwrite = FALSE
) {

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # handle iRODS to R object conversion
  resp <- irods_to_local(
    logical_path = logical_path,
    offset = offset,
    count = count,
    verbose = verbose
  )

  # close connection on exit
  on.exit(close(con))

  # create R connection of raw data
  con <- rawConnection(resp)

  # return R object
  readRDS(gzcon(con))
}

# vectorised iRODS to object or file conversion
irods_to_local <- function(logical_path, offset, count, verbose, local_path = NULL) {

  # object size on iRODS
  object_size <- ils(logical_path, stat = TRUE)[[2]][[2]]

  # when object is larger then cut object in pieces
  if (object_size  > count) {
    # calculated chunk size based on the REST API byte number
    # this is the parameter `count` of the stream end-point
    chunk_size <- calc_chunk_size(object_size, count)
    # vectorised call
    resp <- Map(
      function(offset, count) {
        irods_to_local_(
          logical_path = logical_path,
          offset = offset,
          count = count,
          verbose = verbose,
          local_path = local_path
      )},
      chunk_size[[2]],
      chunk_size[[3]]
    )

    if (is.null(local_path)) {
      # fuse objects from multiple chunks to memory (R environment)
      fuse_object(resp)
    }

  } else {
    irods_to_local_(
      logical_path = logical_path,
      offset = offset,
      count = count,
      verbose = verbose,
      local_path = local_path
    )
  }
}

#' iRODS to object conversion
#' @noRd
irods_to_local_ <- function(logical_path, offset, count, verbose, local_path) {


  # flags to curl call
  args <- list(`logical-path` = logical_path, offset = offset, count = count)

  # http call
  out <- irods_rest_call("stream", "GET", args, verbose)

  # parse response
  resp <- httr2::resp_body_raw(out)

  # stream from multiple chunks directly to disk by streaming
  if (inherits(local_path, "connection")) {
    writeBin(resp, local_path, endian = "swap", useBytes = TRUE)
  } else if (is.null(local_path)) {
    # return response
    resp
  } else {
    stop("Unkown object type.", call. = FALSE)
  }
}
