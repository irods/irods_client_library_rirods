#' Working with data objects
#'
#' @param x R object stored on iRODS server.
#' @param path Destination path.
#' @param offset Offset in bytes into the data object (Defaults to 0).
#' @param count Maximum number of bytes to read or write.
#' @param verbose Show information about the http request and response.
#'
#' @return R object
#' @export
#'
#' @examples
#'
#' # authentication
#' iauth("bobby", "passWORD")
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store
#' iput(foo)
#'
#' # check if file is stored
#' ils()
#'
#' # retrieve in native R format
#' iget("foo")
#'
iput <- function(
    x,
    path = ".",
    offset = 0,
    verbose = FALSE,
    overwrite = FALSE
  ) {

  # what type of object are we dealing with
  if (is.character(x) && file.exists(x)) {
    name <- x
  } else {
    # object name
    name <- deparse(substitute(x))
    # serialize object to raw data
    x <- serialize(x, NULL)
  }

  # logical path
  if (path == ".") {
    lpath <- paste0(.rirods2$current_dir, "/", name)
  } else {
    lpath <- paste0(path, "/", name)
  }

  # flags to curl call
  args <- list(`logical-path` = lpath, offset = offset)

  # http call
  out <- irods_rest_call("stream", "PUT", args, verbose, x)

  # response
  invisible(out)
}
#' @rdname iput
#'
#' @export
iget  <- function(
    x,
    path = x,
    offset = 0,
    count = 1000,
    verbose = FALSE,
    overwrite = FALSE
  ) {

  # make a local copy
  if (x != path) pt <- file.path(path, x) else pt <- x

  # check for local file
  if (isFALSE(overwrite) && is.character(x) && file.exists(pt))
    stop("File exists already. Set the argument `overwrite` to TRUE to",
         "overwrite the file.")

  # logical path
  if (!grepl("/", x)) {
    lpath <- paste0(.rirods2$current_dir, "/", x)
  } else {
    lpath <- x
  }

  # flags to curl call
  args <- list(`logical-path` = lpath, offset = offset, count = count)

  # http call
  out <- irods_rest_call("stream", "GET", args, verbose)

  # parse response
  resp <- httr2::resp_body_raw(out)

  # convert to file or R object
  if (is.character(x) && tools::file_ext(x) %in% c("csv", "tsv")) {
    writeBin(resp, x)
  } else {
    con <- rawConnection(resp)
    readRDS(gzcon(con))
  }
}
