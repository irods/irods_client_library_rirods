#' Store an object into iRODS
#'
#' @inheritParams iadmin
#' @param path Logical path (defaults to working directory)
#' @param data R object stored on iRODS server.
#' @param offset Offset in bytes into the data object (Defaults to 0)
#'
#' @return http response message
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
iput <- function(
    host = "http://localhost/irods-rest/0.9.2",
    path = ".",
    data,
    offset = 0
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

  req <- httr2::request(host) |>
    httr2::req_verbose() |>
    httr2::req_url_path_append("stream") |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_body_raw(raw) |>
    httr2::req_url_query(
      `logical-path` = lpath,
      offset = offset
    ) |>
    httr2::req_method("PUT")

  # response
  httr2::req_perform(req)
}
