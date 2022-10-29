find_host <- function() {

  # find irods file
  irods <- list.files(".", "\\.irods$")

  if (length(irods) == 0)
    stop("Can't connect with iRODS server. Did you supply the correct host",
    "name with `create_riods()`?", call. = FALSE)

  # read irods file
  x <- readLines(irods)
  sub("host: ", "", x)
}

irods_rest_call <- function(
    endpoint,
    verb,
    args,
    verbose,
    object = NULL,
    error = TRUE
  ) {

  # get token from secret environment
  token <- local(token, envir = .rirods)

  # request
  req <- httr2::request(find_host()) |>
    httr2::req_url_path_append(endpoint) |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_method(verb)

  # add further args to request
  req <- do.call(function(...) httr2::req_url_query(req, ...), args)

  # error handling
  if (isTRUE(error))
    req <- httr2::req_error(req, body = irods_errors)

  # the file to be send along
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
    httr2::req_body_raw(req, object),
    tsv = ,
    csv = httr2::req_body_file(req, object),
    json = httr2::req_body_json(req, object, auto_unbox = TRUE, digits = NA,
                                null = "null")
  )
}

# check if irods collection exists
is_collection <- function(current_dir) {

  # initial check
  if (path_exists(current_dir))
    lpath <- ils(path = current_dir, message = FALSE)
  else
    stop("Logical path [", current_dir,"] is not accessible.", call. = FALSE)

  # this cannot be a collection
  if (current_dir %in% lpath$logical_path && lpath$type == "data_object") {
    FALSE
  } else {
    TRUE
  }

}

# check if irods data object exists
is_object <- function(current_dir) !is_collection(current_dir)

# check if irods path exists
path_exists <- function(current_dir) {

  lpath <- try(ils(path = current_dir, message = FALSE), silent = TRUE)

  if (inherits(lpath, "try-error")) {
    FALSE
  } else {
    TRUE
  }
}
