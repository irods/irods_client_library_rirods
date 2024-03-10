#' The Administration Interface to iRODS
#'
#' Note that this function can only be used with admin rights.
#'
#' @param name Name of user to be added.
#' @param password Password to be added.
#' @param action The action: `"create_user"`, `"remove_user"`, or `"set_password"`.
#' @param role Role of user: `"rodsuser"`, `"groupadmin"`, and `"groupadmin"`.
#' @param verbose Show information about the http request and response.
#'  Defaults to `FALSE`.
#'
#' @return Invisible http status.
#' @export
#'
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#'
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' # use_irods_demo()
#' \dontshow{
#' .old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
#' Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
#' }
#' # connect project to server
#' \Sexpr[stage=build, results=rd]{paste0("create_irods(\"", rirods:::.irods_host, "\")")}
#'
#' # authentication
#' iauth("rods", "rods")
#'
#' # add user
#' iadmin("Alice", action = "create_user", role = "rodsuser")
#'
#' # add user password
#' iadmin("Alice", "pass", action = "set_password",  role = "rodsuser")
#'
#' # delete user
#' iadmin("Alice", action = "remove_user", role = "rodsuser")
#' \dontshow{
#' Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
#' }
iadmin <- function(
    name,
    password = character(1),
    action = c("create_user", "set_password", "remove_user"),
    role = c("rodsuser", "groupadmin", "rodsadmin"),
    verbose = FALSE
  ) {

  match.arg(action)
  match.arg(role)

  if (check_user_exists(name) && length(password) == 0)
    stop("User ", name, " already exists.")

  args <- list(
    op = action,
    zone = find_irods_file("irods_zone"),
    `user-type` = role,
    name = name
  )

  if (grepl("password", action)) {
    args$`new-password` <- password
  }

  resp <- irods_http_call("users-groups", "POST", args, verbose = FALSE) |>
    httr2::req_perform()

  invisible(resp)
}

check_user_exists <- function(name) {
  name %in% list_users_irods_zone()
}

list_users_irods_zone <- function() {
  resp <- irods_http_call("users-groups", "GET", list(op="users"), verbose = FALSE) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  vapply(resp$users, "[[", character(1), "name")
}
