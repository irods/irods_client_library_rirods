#' Working with iRODS data objects
#'
#' Store a file into iRODS with `iput()`. If the destination data-object or
#' collection are not provided, the current iRODS directory and the input file
#' name are used. Get data-objects or collections from iRODS space with `iget()`
#' , either to the specified local area or to the current working directory.
#'
#' @param local_path File stored on iRODS server.
#' @param logical_path Destination path.
#' @param offset Offset in bytes into the data object (Defaults to FALSE).
#' @param truncate Truncates the object on open (defaults to TRUE).
#' @param count Maximum number of bytes to read or write.
#' @param verbose Show information about the http request and response.
#' @param overwrite Overwrite irods object or local file (defaults to FALSE).
#'
#' @return Invisibly the http response in case of `iput()`, or invisibly NULL in
#' case of `iget()`.
#'
#' @export
#'
#' @examples
#' if(interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authentication
#' iauth()
#'
#' # creates a csv local file of the iris dataset
#' library(readr)
#' write_csv(iris, "iris.csv")
#'
#' # store to iRODS
#' iput("iris.csv")
#'
#' # delete local file
#' unlink("iris.csv")
#'
#' # check if file is stored
#' ils()
#'
#' # write to local file
#' iget("iris.csv")
#'
#' # check local files
#' list.files()
#' }
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

  # what type of object are we dealing with
  if (!(is.character(local_path) && file.exists(local_path))) {
    stop("Local file [", basename(local_path) , "] does not exist.",
         call. = FALSE)
  }

  # handle file to iRODS conversion
  out <-local_to_irods(
    local_path = local_path,
    logical_path = logical_path,
    offset = offset,
    count = count,
    truncate = truncate,
    verbose = verbose
  )

  invisible(out[[1]])
}

#' iRODS serialization Interface for Single R Objects
#'
#' Store an in-memory R object in iRODS with `isaveRDS()`. If the destination
#' data-object or collection are not provided, the current iRODS collection and
#' the input R object name are used. Get data-objects or collections from iRODS
#' space in memory (R environment) with `ireadRDS()`.
#'
#' @param x R object stored on iRODS server.
#' @param logical_path Destination path.
#' @param offset Offset in bytes into the data object (Defaults to FALSE).
#' @param truncate Truncates the object on open (defaults to TRUE).
#' @param count Maximum number of bytes to read or write.
#' @param verbose Show information about the http request and response.
#' @param overwrite Overwrite irods object or local file (defaults to FALSE).
#'
#' @return Invisibly the http response in case of `isaveRDS()`, or an R object
#' in case of `ireadRDS()`.
#'
#' @export
#'
#' @examples
#' if(interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authentication
#' iauth()
#'
#' # store into iRODS
#' isaveRDS(iris, "iris.rds")
#'
#' # check if file is stored
#' ils()
#'
#' # retrieve in native R format
#' ireadRDS("iris.rds")
#' }
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

  # serialize R object
  if (exists(name, envir = parent.frame())) {
    # # make intermediate file
    fil <- tempfile(name, fileext = ".rds")
    # serialize and gz compress
    saveRDS(x, fil)
  } else {
    stop("Local object [", name ,"] does not exist.", call. = FALSE)
  }

  # handle R object to iRODS conversion
  out <- local_to_irods(
    local_path = fil,
    logical_path = logical_path,
    offset = offset,
    count = count,
    truncate = truncate,
    verbose = verbose
  )

  invisible(out[[1]])
}

# vectorised object to irods conversion
local_to_irods <- function(local_path, logical_path, offset, count, truncate,
                           verbose) {

  # when object is larger then cut object in pieces
  if (file.size(local_path) > count) {
    #---------------------------------------------------------------------------
    # this is a hack to make it work
    pl <- tempfile(
      "place_holder",
      fileext = paste0(".", tools::file_ext(local_path))
    )
    saveRDS("place_holder", pl)
    # flags to curl call
    args <- list(
      `logical-path` = logical_path,
      offset = offset,
      count = count
    )
    irods_rest_call("stream", "PUT", args, verbose, pl)
    truncate <- "false"
    #---------------------------------------------------------------------------
    x <- chunk_file(local_path, count)
  } else {
    x <- list(local_path, offset = 0, count)
  }

  # vectorised call of file which enables chunked file transfer in case of larger
  # file size than `count` bytes
  Map(
    function(x, y, z) {
      local_to_irods_(
        local_path = x,
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
# internal: object to irods conversion
local_to_irods_ <- function(
    local_path,
    logical_path,
    offset,
    count,
    truncate,
    verbose
  ) {

  # flags to curl call
  args <- list(
    `logical-path` = logical_path,
    offset = offset,
    count = count,
    truncate = truncate
  )

  # http call
  irods_rest_call("stream", "PUT", args, verbose, local_path)
}


#' @rdname iput
#'
#' @export
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

  # handle iRODS to local file conversion
  resp <- irods_to_local(
    logical_path = logical_path,
    offset = offset,
    count = count,
    verbose = verbose
  )

  # check for local file
  stop_local_overwrite(overwrite, local_path)

  # close connection on exit
  on.exit(close(con))

  # write file
  con <- file(local_path, "wb")
  writeBin(resp, con)

  # return
  invisible(NULL)
}

#' @rdname isaveRDS
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

  # create R object
  con <- rawConnection(resp)

  # return r object
  readRDS(gzcon(con))
}

# vectorised irods to object conversion
irods_to_local <- function(logical_path, offset, count, verbose) {

  # file size on irods
  file_size <- ils(logical_path, stat = TRUE)[[2]][[2]]

  # when object is larger then cut object in pieces
  if (file_size  > count) {
    # chunk size
    chunk_size <- calc_chunk_size(file_size, count)
    # vectorised call
    resp <- Map(
      function(offset, count) {
        irods_to_local_(
          logical_path = logical_path,
          offset = offset,
          count = count,
          verbose = verbose
      )},
      chunk_size[[2]],
      chunk_size[[3]]
    )

    # fuse files
    fuse_file(resp)
  } else {
    irods_to_local_(
      logical_path = logical_path,
      offset = offset,
      count = count,
      verbose = verbose
    )
  }
}

# internal: irods to object conversion
irods_to_local_ <- function(logical_path, offset, count, verbose) {

  # flags to curl call
  args <- list(`logical-path` = logical_path, offset = offset, count = count)

  # http call
  out <- irods_rest_call("stream", "GET", args, verbose)

  # parse response
  httr2::resp_body_raw(out)
}
