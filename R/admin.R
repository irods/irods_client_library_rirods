#' The Administration Interface to iRODS
#'
#' Note that this function can only be used with admin rights.
#'
#' @param action The action: add, modify, or remove.
#' @param target The subject of the action: user, zone, resource, childtoresc,
#   childfromresc, token, group, rebalance, unusedAVUs, specificQuery.
#' @param arg2 arg2
#' @param arg3 arg3
#' @param arg4 arg4
#' @param arg5 arg5
#' @param arg6 arg6
#' @param arg7 arg7
#' @param verbose Show information about the http request and response.
#'  Defaults to `FALSE`.
#'
#' @return Invisible http status.
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#'
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' # use_irods_demo()
#'
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authentication
#' iauth("rods", "rods")
#'
#' # add user
#' iadmin(action = "add", target = "user", arg2 = "Bob", arg3 = "rodsuser")
#'
#' # add user password
#' iadmin(action = "modify", target = "user", arg2 = "Bob", arg3 = "password",
#'   arg4 = "pass")
#'
#' # delete user
#' iadmin(action = "remove", target = "user", arg2 = "Bob")
#'
iadmin <- function(
    action,
    target,
    arg2 = character(1),
    arg3 = character(1),
    arg4 = character(1),
    arg5 = character(1),
    arg6 = character(1),
    arg7 = character(1),
    verbose = FALSE
  ) {

  args <- list(
    action = action,
    target = target,
    arg2 = arg2,
    arg3 = arg3,
    arg4 = arg4,
    arg5 = arg5,
    arg6 = arg6,
    arg7 = arg7
  )

  # http call
  resp <- irods_rest_call("admin", "POST", args, verbose)

  invisible(resp)
}
