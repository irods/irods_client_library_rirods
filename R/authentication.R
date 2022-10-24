#' Authentication service for the iRODS zone
#'
#' @param user iRODS user name.
#' @param password iRODS password.

#'
#' @return String
#' @export
#'
#' @examples
#' if(interactive()) {
#' # authenticate
#' iauth()
#' }
iauth <- function(user = NULL, password = NULL) {

  # ask for credentials
  if (is.null(user)) {
    user <- askpass::askpass("Please enter your username:")
  }
  if (is.null(password)) {
    password <- askpass::askpass()
  }

  # get token
  token <- get_token(paste(user, password, sep =":"))

  # store token
  assign("token", token, envir = .rirods2)

  # starting dir as admin or user
  if (user == "rods") {
    start_rirods <- "/tempZone/home"
  } else {
    start_rirods <- paste0("/tempZone/home/", user)
  }

  .rirods2$current_dir <- start_rirods

  invisible(NULL)
}

rirods_env <- function(var) {

  if(!exists(var, envir = .rirods2)) {
    stop(var, " was not found! Try `iinit()` to start irods session.")
  }

  local(var, envir = .rirods2)
}

get_token <- function(details, host = "http://localhost/irods-rest/0.9.2") {

  secret <- system(paste("echo -n", details, "| base64"), intern = TRUE) # password and user as variables

  req <- httr2::request(host) |>
    httr2::req_url_path_append("auth") |>
    httr2::req_headers(Authorization = paste0("Basic ", secret)) |>
    httr2::req_method("POST")

  httr2::req_perform(req) |>
    httr2::resp_body_string()
}
