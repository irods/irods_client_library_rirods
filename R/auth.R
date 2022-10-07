#' Authentication service for the iRODS zone
#'
#' @inheritParams riadmin
#'
#' @return String
#' @export
#'
#' @examples
#'
#' # get token
#' get_token()
#'
get_token <- function(host = "http://localhost/irods-rest/0.9.2") {

  secret <- system("echo -n rods:rods | base64", intern = TRUE)

  req <- httr2::request(host) |>
    httr2::req_url_path_append("auth") |>
    httr2::req_headers(Authorization = paste0("Basic ", secret)) |>
    httr2::req_method("POST")

  httr2::req_perform(req) |>
    httr2::resp_body_string()
}
