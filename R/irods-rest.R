#' Internal function to coordinate iRODS REST call
#'
#' @param endpoint REST API end-point.
#' @param verb The HTTP verb to be used (e.g. PUT).
#' @param args The arguments to be set for the end-point.
#' @param verbose Verbosity of the HTTP request.
#' @param object Data to send along with HTTP request.
#' @param error Whether status codes larger than 400 should be translated to
#'  errors.
#'
#' @references https://github.com/irods/irods_demo/tree/main/irods_client_rest_cpp
#' @keywords internal
#' @return HTTP response
irods_rest_call <- function(
    endpoint,
    verb,
    args,
    verbose,
    object = NULL,
    error = TRUE
) {

  # check connection
   if (!is_connected_irods()) stop("Not connected to iRODS.", call. = FALSE)

  # get token from secret environment
  token <- local(token, envir = .rirods)

  # request
  req <- httr2::request(find_irods_file("host")) |>
    httr2::req_url_path_append(endpoint) |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_method(verb)

  # add further args to request
  req <- do.call(function(...) httr2::req_url_query(req, ...), args)

  # error handling
  if (isTRUE(error))
    req <- handle_irods_errors(req)

  if (!is.null(object)) {
    if (is.character(object) && file.exists(object)) {
      # get type of object to be stored
      type <- tools::file_ext(object) |> unique()
    } else {
      type <- deparse(substitute(object))
    }
    req <- data_switch(type, req, object)
  }

  # verbose request response status
  if (isTRUE(verbose))
    req <- httr2::req_verbose(req)

  # response
  httr2::req_perform(req)
}

handle_irods_errors <- function(req) {
  httr2::req_retry(
    req,
    max_tries = 3,
    is_transient = ~ httr2::resp_status(.x) %in% c(429, 503)
  ) |>
    httr2::req_error(body = irods_errors) # show if nothing works
}

# irods rest api errors
irods_errors <- function(resp) {
  # json for irods internal errors, except for nginx bad gateway 502
  if (!httr2::resp_status(resp) %in% c(429, 502, 503)) {
    httr2::resp_body_json(resp, check_type = FALSE)$error_message
  } else if (httr2::resp_status(resp) == 502) {
    paste0(
      httr2::resp_body_html(resp, check_type = TRUE)$error_message,
      " The iRODS server might be malconfigured."
    )
  } else {
    httr2::resp_body_html(resp, check_type = TRUE)$error_message
  }
}

# figure out what type of data is to be send
data_switch <- function(type, req, object) {
  switch(
    type,
    json = httr2::req_body_json(req, object, auto_unbox = TRUE, digits = NA,
                                null = "null"),
    object = httr2::req_body_raw(req, object)
  )
}
