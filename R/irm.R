#' Delete an object from iRODS
#'
#' @inheritParams iput
#' @param trash Send to trash or delete permanently (default = TRUE).
#' @param recursive Recursively delete contents of a collection
#'  (default = FALSE).
#' @param unregister Unregister data objects instead of deleting them
#'  (default = FALSE).
#'
#' @return
#' @export
#'
#' @examples
irm <- function(
    host = "http://localhost/irods-rest/0.9.2",
    file = "/tempZone/home",
    trash = TRUE,
    recursive = FALSE,
    unregister = FALSE
  ) {

  token <- local(token, envir = .rirods2)

  req <- httr2::request(host) |>
    httr2::req_url_path_append("logicalpath") |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_query(
      `logical-path` = file,
      `no-trash` = as.integer(trash),
      recursive = as.integer(recursive)
    ) |>
    httr2::req_method("DELETE")

  # response
  httr2::req_perform(req)
}

