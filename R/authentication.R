#' Authentication service for the iRODS zone
#'
#' Provides an authentication service for the iRODS zone. Using the function
#' without arguments results in a prompt asking for the user name and password
#' thereby preventing hard-coding of sensitive information in scripts.
#'
#' @param user iRODS user name (prompts user for user name if not supplied).
#' @param password iRODS password (prompts user for password if not supplied).
#' @param zone_path iRODS zone path (defaults to "/tempZone/home").
#' @param role iRODS role of user (defaults to "rodsuser").
#'
#' @return Invisibly NULL
#' @export
#'
#' @examples
#' if(interactive()) {
#' # authenticate
#' iauth()
#' }
iauth <- function(user = NULL, password = NULL, role = "rodsuser") {

  # ask for credentials
  if (is.null(user)) {
    user <- askpass::askpass("Please enter your username:")
  }
  if (is.null(password)) {
    password <- askpass::askpass()
  }

  # get token
  token <- get_token(paste(user, password, sep = ":"), find_irods_file("host"))

  # store token
  assign("token", token, envir = .rirods)

  # starting dir as admin or user
  if (role == "rodsadmin") {
    start_rirods <- find_irods_file("zone_path")
  } else if (role == "rodsuser") {
    # check path formatting, does it end with "/"? If not, then add it.
    if (!grepl("/$", find_irods_file("zone_path")))
      zone_path <- paste0(find_irods_file("zone_path"), "/")
    start_rirods <- paste0(zone_path, user)
  } else {
    stop("Unkown role of user.")
  }

  .rirods$current_dir <- start_rirods

  invisible(NULL)
}

get_token <- function(details, host) {

  # password and user as variables
  secret <- base64enc::base64encode(charToRaw(details))

  # request
  req <- httr2::request(host) |>
    httr2::req_url_path_append("auth") |>
    httr2::req_headers(Authorization = paste0("Basic ", secret)) |>
    httr2::req_method("POST") |>
    httr2::req_error(body = irods_errors)

  # response
  httr2::req_perform(req) |>
    httr2::resp_body_string()
}
