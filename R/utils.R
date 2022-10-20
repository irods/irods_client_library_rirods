find_host <- function() {

  # find irods file
  irods <- list.files(".", "\\.irods$")
  # read irods file
  x <- readLines(irods)
  sub("host: ", "", x)
}

irods_rest_call <- function(endpoint, verb, args, verbose, object = NULL) {

  # get token from secret environment
  token <- local(token, envir = .rirods2)

  # request
  req <- httr2::request(find_host()) |>
    httr2::req_url_path_append(endpoint) |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_method(verb)

  # add further args to request
  req <- do.call(function(...) httr2::req_url_query(req, ...), args)

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

# figure out what type of data is to be send
data_switch <- function(type, req, object) {

  switch(
    type,
    httr2::req_body_raw(req, object),
    tsv = ,
    csv = httr2::req_body_file(req, object),
    json = httr2::req_body_json(req, object, auto_unbox = TRUE, digits = NA, null = "null")
  )
}

ifile.exists <- function(){}
