#' The administration interface to the iRODS
#'
#' @param action The action: add, modify, or remove.
#' @param target The subject of the action: user, zone, resource, childtoresc,
#'  childfromresc, token, group, rebalance, unusedAVUs, specificQuery.
#' @param arg2 arg2
#' @param arg3 arg3
#' @param arg4 arg4
#' @param arg5 arg5
#' @param arg6 arg6
#' @param arg7 arg7
#' @param verbose Show information about the http request and response.
#'
#' @return Invisible on success (200) otherwise http status.
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

  token <- local(token, envir = .rirods2)

  # request
  req <- httr2::request(find_host()) |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_query(
      action = action,
      target = target,
      arg2 = arg2,
      arg3 = arg3,
      arg4 = arg4,
      arg5 = arg5,
      arg6 = arg6,
      arg7 = arg7
    ) |>
    httr2::req_url_path_append("admin") |>
    httr2::req_method("POST") |>
    httr2::req_error(body = irods_errors, is_error = function(resp) FALSE)

  # verbose request response status
  if (isTRUE(verbose)) req <- httr2::req_verbose(req)

  # response
  resp <- httr2::req_perform(req)

  if (httr2::resp_status(resp) >= 400) invisible(NULL) else invisible(resp)
}

