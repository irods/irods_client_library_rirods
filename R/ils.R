#' Listing
#'
#' Recursive listing of a collection, or stat, metadata, and access control
#' information for a given data object.
#'
#' @inheritParams riadmin
#' @param path Directory to be listed.
#' @param stat Boolean flag to indicate stat information is desired
#' @param permissions  Boolean flag to indicate access control information is desired
#' @param metadata Boolean flag to indicate metadata is desired
#' @param offset Number of records to skip for pagination
#' @param limit Number of records desired per page
#'
#' @return tibble with logical paths
#' @export
#'
#' @examples
#'
#' # list home directory
#' rils(token = get_token())
#'
rils <- function(
    host = "http://localhost/irods-rest/0.9.2",
    path = "/tempZone/home",
    token,
    stat = FALSE,
    permissions = FALSE,
    metadata = FALSE,
    offset = 0,
    limit = 100
  ) {

  req <- httr2::request(host) |>
    httr2::req_url_path_append("list") |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_query(
      `logical-path` = path,
      stat = as.integer(stat),
      permissions = as.integer(permissions),
      metadata = as.integer(metadata),
      offset = offset,
      limit = limit
    )

  # response
  resp <- httr2::req_perform(req)

  httr2::resp_body_json(resp, check_type = FALSE, simplifyVector = TRUE)$`_embedded` |> tibble::as_tibble()

}
