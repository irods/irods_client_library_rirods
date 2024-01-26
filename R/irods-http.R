#' Internal function to coordinate iRODS HTTP call
#'
#' @param endpoint HTTP API end-point.
#' @param verb The HTTP verb to be used (e.g. PUT).
#' @param args The arguments to be set for the end-point.
#' @param verbose Verbosity of the HTTP request.
#' @param error Whether status codes larger than 400 should be translated to
#'  errors.
#'
#' @references https://github.com/irods/irods_client_http_api
#' @keywords internal
#' @return HTTP response
irods_http_call <- function(
  endpoint,
  verb,
  args,
  verbose,
  error = TRUE
) {

  # check connection
  if (!is_connected_irods()) stop("Not connected to iRODS.", call. = FALSE)

  # get token from secret environment
  token <- local(token, envir = .rirods)

  # request
  req <- httr2::request(find_irods_file("host")) |>
    httr2::req_url_path_append(endpoint) |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_method(verb)

  # add further args to request
  if (verb == "GET") {
    req <- do.call(function(...) httr2::req_url_query(req, ...), args)
  } else if (verb == "POST") {
    if (is.null(args$bytes)) {
      req <- do.call(function(...) httr2::req_body_form(req, ...), args)
    } else {
      drop_list_values <- names(args) != "bytes" & !vapply(args, is.null, logical(1))
      args[drop_list_values] <- vapply(args[drop_list_values], as.character, character(1))
      req <- do.call(function(...) httr2::req_body_multipart(req, ...), args)
    }
  }

  # error handling
  if (isTRUE(error))
    req <- handle_irods_errors(req)

  # verbose request response status
  if (isTRUE(verbose))
    req <- httr2::req_verbose(req)

  req
}

handle_irods_errors <- function(req) {
  httr2::req_retry(
    req,
    max_tries = 3,
    is_transient = ~ httr2::resp_status(.x) %in% c(429, 503)
  ) |>
    httr2::req_error(body = irods_errors) # show if nothing works
}

# iRODS rest api errors
irods_errors <- function(resp) {
  # json for iRODS internal errors, except for nginx bad gateway 502
  if (httr2::resp_status(resp) >= 500 && httr2::resp_status(resp) < 600) {
    irods_message <- try(httr2::resp_body_json(resp, check_type = TRUE)$error_message, silent = TRUE)
    paste0(
      ifelse(inherits(irods_message, "try-error"), "", irods_message),
      "The iRODS server might be malconfigured."
    )
  } else if (length(resp$body) != 0) {
    resp <- httr2::resp_body_json(resp, check_type = FALSE) |> unlist()
    paste(names(resp), vapply(resp, as.character, character(1)), sep = ": ")
  } else {
    "This is likely a malformed HTTP request."
  }
}
