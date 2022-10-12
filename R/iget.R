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
iget  <- function(
    host = "http://localhost/irods-rest/0.9.2",
    data,
    offset = 0,
    count = 1000
) {

  # filename creates a local copy (caching with)

  token <- local(token, envir = .rirods2)

  # logical path
  if (!grepl("/", data)) {
    lpath <- paste0(.rirods2$current_dir, "/", data)
  } else {
    lpath <- data
  }


  req <- httr2::request(host) |>
    httr2::req_url_path_append("stream") |> httr2::req_verbose() |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_query(
      `logical-path` = lpath,
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
