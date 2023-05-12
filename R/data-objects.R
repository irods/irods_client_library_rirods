#' Save files and objects in iRODS
#'
#' Store an object or file into iRODS. `iput()` should be used to transfer
#' a file from the local storage to iRODS; `isaveRDS()` saves an R object from the
#' current environment in iRODS in RDS format (see `saveRDS()`).
#'
#' @param local_path Local path of file to be sent to iRODS.
#' @param x R object to save in iRODS.
#' @param logical_path Destination path in iRODS.
#'    By default, the basename of `local_path` is used and the file is
#'    stored in the current working directory (see `ipwd()`).
#' @param offset Offset in bytes into the data object. Defaults to 0.
#' @param count Maximum number of bytes to write. Defaults to 2000.
#' @param truncate Whether to truncate the object when opening it. Defaults to `TRUE`.
#' @param verbose Whether to print information about the HTTP request and response.
#' @param overwrite Whether the file in iRODS should be overwritten if it exists.
#'     Defaults to `FALSE`.
#'
#' @return (Invisibly) the HTTP response.
#' @export
#'
#' @examples
#' if (interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home", TRUE)
#'
#' # authenticate
#' iauth()
#'
#' # save the iris dataset as csv and send the file to iRODS
#' library(readr)
#' write_csv(iris, "iris.csv")
#' iput("iris.csv", overwrite = TRUE)
#'
#' # save with a different name
#' iput("iris.csv", "irids_in_irods.csv", overwrite = TRUE)
#' ils()
#'
#' # send an R object to iRODS in RDS format
#' isaveRDS(iris, "irids_in_rds.rds", overwrite = TRUE)
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

#' Object to iRODS conversion
#' @noRd
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


#' Retrieve file or object from iRODS
#'
#' Transfer a file from iRODS to the local storage with `iget()` or
#' read an R object from an RDS file in iRODS with `ireadRDS()` (see `readRDS()`).
#'
#' @param logical_path Source path in iRODS.
#' @param local_path Destination path in local storage. By default,
#'   the basename of the logical path; the file will be stored in the current
#'   directory (see `getwd()`).
#' @param offset Offset in bytes into the data object. Defaults to 0.
#' @param count Maximum number of bytes to write. Defaults to 2000.
#' @param verbose Whether information should be printed about the HTTP request and response.
#' @param overwrite Whether the local file should be overwritten if it exists.
#'    Defaults to `FALSE`.
#'
#' @return The R object in case of `ireadRDS()`, invisibly `NULL` in case of `iget()`.
#' @export
#'
#' @examples
#' if (interactive()) {
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home", TRUE)
#'
#' # authenticate
#' iauth()
#'
#' # save the iris dataset as csv and send the file to iRODS
#' library(readr)
#' write_csv(iris, "iris.csv")
#' iput("iris.csv", overwrite = TRUE)
#'
#' # bring the file back with a different name
#' iget("iris.csv", "new_iris.csv", overwrite = TRUE)
#' files.exists("new_iris.csv") # check that it has been transferred
#'
#' # send an R object to iRODS in RDS format
#' isaveRDS(iris, "irids_in_rds.rds")
#'
#' # read it back
#' iris_again <- ireadRDS("irids_in_rds.rds")
#' iris_again
#' }
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

#' irods to object conversion
#' @noRd
irods_to_local_ <- function(logical_path, offset, count, verbose) {

  # flags to curl call
  args <- list(`logical-path` = logical_path, offset = offset, count = count)

  # http call
  out <- irods_rest_call("stream", "GET", args, verbose)

  # parse response
  httr2::resp_body_raw(out)
}
