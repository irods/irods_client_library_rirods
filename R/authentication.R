#' Authentication Service for an iRODS Zone
#'
#' Provides an authentication service for an iRODS zone. Using the function
#' without arguments results in a prompt asking for the user name and password
#' thereby preventing hard-coding of sensitive information in scripts.
#'
#' @param user iRODS user name (prompts user for user name if not supplied).
#' @param password iRODS password (prompts user for password if not supplied).
#' @param role iRODS role of user (defaults to `"rodsuser"`).
#'
#' @return Invisibly `NULL`.
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#'
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' # use_irods_demo()
#'
#' # connect project to server
#' create_irods("http://localhost:9001/irods-http-api/0.1.0")
#'
#' # authenticate
#' iauth("rods", "rods")
#'
iauth <- function(user, password = NULL, role = "rodsuser") {

  .rirods$user <- user

  # get token
  token <- get_token(user, password, find_irods_file("host"))

  # store token
  assign("token", token, envir = .rirods)

  # add additional server information to config file
  irods_conf_file <- path_to_irods_conf()
  server_info <- jsonlite::fromJSON(irods_conf_file)

  if (length(server_info) == 1) {
    export <-
      jsonlite::toJSON(append(server_info , get_server_info(FALSE)),
                       auto_unbox = TRUE,
                       pretty = TRUE)
    write(export, file = irods_conf_file)
  }

  # starting dir as admin or user
  .rirods$user_role <- role
  .rirods$current_dir <- make_irods_base_path()

  invisible(NULL)
}

get_token <- function(user, password, host) {

  # request
  req <- httr2::request(host) |>
    httr2::req_method("POST") |>
    httr2::req_auth_basic(user, password) |>
    handle_irods_errors() |>
    httr2::req_url_path_append("authenticate")

  # response
  httr2::req_perform(req) |>
    httr2::resp_body_string()
}

#' Predicate for iRODS Connectivity
#'
#' A predicate to check whether you are currently connected to an iRODS server.
#'
#' @param ... Currently not implemented.
#' @return Boolean whether or not a connection to iRODS exists.
#' @export
#'
#' @examples
#' is_connected_irods()
is_connected_irods <- function(...) {

  if (is.null(.rirods$token)) FALSE else TRUE
}

is_api_type <- function(host, type) {
  if (grepl("irods-http-api", host)) {
    api_type <- "http"
  } else if (grepl("irods-rest", host)) {
    api_type <- "rest"
  } else {
    stop("Unknown iRODS api type.")
  }
  api_type == type
}
