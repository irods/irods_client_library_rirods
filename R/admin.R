#' The administration interface to the iRODS
#'
#' @param host Url of host
#' @param token Token for authentication
#' @param action The action: add, modify, or remove.
#' @param target The subject of the action: user, zone, resource, childtoresc,
#'  childfromresc, token, group, rebalance, unusedAVUs, specificQuery.
#' @param ... Addition arguments (arg1 up to arg7)
#'
#' @return Invisible on success (200) otherwise http status.
#' @export
#'
#' @examples
#'
#' # get token
#' tk <- get_token()
#'
#' # add user bobby
#' riadmin(token = tk, action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
#'
#' # check if bobby is added
#' rils(tk)
#'
#' # remove user bobby
#' riadmin(token = tk, action = "remove", target = "user", arg2 = "bobby")
#'
#' # check if bobby is removed
#' rils(tk)
#'
riadmin <- function(host = "http://localhost/irods-rest/0.9.2", token, action, target, ...) {

  # check dots
  ellipsis::check_dots_used()
  add_args <- add_args(...)

  # request
  req <- httr2::request(host) |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_path_append("admin") |>
    httr2::req_url_query(action = action, target = target, rlang::splice(add_args)) |>
    httr2::req_method("POST")

  # response
  resp <- req |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()

  if (httr2::resp_status(resp) >= 400) 0 else resp
}

add_args <- function(arg2 = character(1), arg3 = character(1), arg4 = character(1), arg5 = character(1), arg6 = character(1), arg7 = character(1)) {
  list(arg2, arg3, arg4, arg5, arg6, arg7) |>
    setNames(c("arg2", "arg3", "arg4", "arg5", "arg6", "arg7"))
}
