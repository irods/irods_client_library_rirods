#' Store an object into iRODS
#'
#' @inheritParams iadmin
#' @param file R object stored on iRODS server.
#' @param offset Offset in bytes into the data object (Defaults to 0)
#'
#' @return http response message
#' @export
#'
#' @examples
#'
#' # authenticate
#' auth()
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store
#' iput(file = foo, path = "/tempZone/home/rods")
#'
iput <- function(
    host = "http://localhost/irods-rest/0.9.2",
    path = "/tempZone/home",
    file,
    offset = 0
) {

  token <- local(token, envir = .rirods2)
  name <- deparse(substitute(file))

  # serialize object to raw data
  raw <- serialize(file, NULL)

  req <- httr2::request(host) |>
    httr2::req_verbose() |>
    httr2::req_url_path_append("stream") |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_body_raw(raw) |>
    httr2::req_url_query(
      `logical-path` = file.path(path, name),
      offset = offset
    ) |>
    httr2::req_method("PUT")

  # response
  httr2::req_perform(req)
}
