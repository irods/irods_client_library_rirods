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
    req <- httr2::req_error(req, body = irods_errors)

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

# irods rest api errors
irods_errors <- function(resp) {
  httr2::resp_body_json(resp, check_type = FALSE)$error_message
}

# figure out what type of data is to be send
data_switch <- function(type, req, object) {

  switch(
    type,
    rds = httr2::req_body_file(req, object),
    txt = ,
    tsv = ,
    csv = httr2::req_body_file(req, object),
    json = httr2::req_body_json(req, object, auto_unbox = TRUE, digits = NA,
                                null = "null")
  )
}
