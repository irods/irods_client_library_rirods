#' Retrieve an object from iRODS
#'
#' @inheritParams iput
#' @param count Maximum number of bytes to read or write
#'
#' @return R object
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
#' # retrieve in native R format
#' iget(file = "/tempZone/home/rods/foo")
#'
iget  <- function(
    host = "http://localhost/irods-rest/0.9.2",
    file = "/tempZone/home",
    path = ".",
    offset = 0,
    count = 1000
) {

  token <- local(token, envir = .rirods2)

  req <- httr2::request(host) |>
    httr2::req_url_path_append("stream") |> httr2::req_verbose() |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_query(
      `logical-path` = file,
      offset = offset,
      count = count
    )

  # response
  resp <- httr2::req_perform(req) |>
    httr2::resp_body_raw()

  # convert to R object
  con <- rawConnection(resp)
  readRDS(gzcon(con))
  # out <- unserialize(con)
  # close(con)
  # out
}
