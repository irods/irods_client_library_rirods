#' Working with data objects
#'
#' @inheritParams iadmin
#' @param path Logical path (defaults to working directory).
#' @param data R object stored on iRODS server.
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
#' auth()
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # set working directory to rods
#' icd("/tempZone/home/rods")
#'
#' # store
#' iput(data = foo)
#'
#' # check if file is stored
#' ils()
#'
#' # retrieve in native R format
#' iget(data = "foo")
#'
iput <- function(
    host = "http://localhost/irods-rest/0.9.2",
    path = ".",
    data,
    offset = 0,
    verbose = FALSE
) {

  # overwrite argument which defaults to FALSE and associated error
  token <- local(token, envir = .rirods2)
  name <- deparse(substitute(data))

  # serialize object to raw data
  raw <- serialize(data, NULL)
  if (path == ".") {
    lpath <- paste0(.rirods2$current_dir, "/", name)
  } else {
    lpath <- paste0(path, "/", name)
  }

  # request
  req <- httr2::request(host) |>
    httr2::req_url_path_append("stream") |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_body_raw(raw) |>
    httr2::req_url_query(
      `logical-path` = lpath,
      offset = offset
    ) |>
    httr2::req_method("PUT")

  # verbose request response status
  if (isTRUE(verbose)) req <- httr2::req_verbose(req)

  # response
  invisible(httr2::req_perform(req))
}
#' @rdname iput
#'
#' @export
iget  <- function(
    host = "http://localhost/irods-rest/0.9.2",
    data,
    offset = 0,
    count = 1000,
    verbose = FALSE
) {

  # filename creates a local copy (caching with)

  token <- local(token, envir = .rirods2)

  # logical path
  if (!grepl("/", data)) {
    lpath <- paste0(.rirods2$current_dir, "/", data)
  } else {
    lpath <- data
  }

  # request
  req <- httr2::request(host) |>
    httr2::req_url_path_append("stream") |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_query(
      `logical-path` = lpath,
      offset = offset,
      count = count
    )

  # verbose request response status
  if (isTRUE(verbose)) req <- httr2::req_verbose(req)

  # response
  resp <- httr2::req_perform(req) |>
    httr2::resp_body_raw()

  # convert to R object
  con <- rawConnection(resp)
  readRDS(gzcon(con))
}
