#' Delete an object from iRODS
#'
#' @inheritParams iput
#' @param trash Send to trash or delete permanently (default = TRUE).
#' @param recursive Recursively delete contents of a collection
#'  (default = FALSE).
#' @param unregister Unregister data objects instead of deleting them
#'  (default = FALSE).
#'
#' @return Invisible object to be removed
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
#' # delete object
#'
#' irm(data = "foo", trash = FALSE)
#'
#' # check if file is delete
#' ils()
irm <- function(
    host = "http://localhost/irods-rest/0.9.2",
    data,
    trash = TRUE,
    recursive = FALSE,
    unregister = FALSE
  ) {

  token <- local(token, envir = .rirods2)

  # logical path
  if (!grepl("/", data)) {
    lpath <- paste0(.rirods2$current_dir, "/", data)
  } else {
    lpath <- data
  }

  req <- httr2::request(host) |>
    httr2::req_url_path_append("logicalpath") |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_query(
      `logical-path` = lpath,
      `no-trash` = as.integer(trash),
      recursive = as.integer(recursive)
    ) |>
    httr2::req_method("DELETE")

  # response
  httr2::req_perform(req)
}

