function (response) {

  # mask host in headers
  response$url <- gsub(rirods:::find_irods_file("host"), "", response$url, fixed = TRUE)

  # token
  if (inherits(response, "httr2_response")) {
    response$request$headers$Authorization  <- ""
  }

  # mask dates in headers
  response$headers$Date <- ""

  # change body upon PUT when type is raw (`iput()` and `isaverds()`)
  if (inherits(response, "httr2_request") &&
      inherits(response$body$data$bytes,  "form_data")) {
    response$body$data <- NULL
  }

  response
}
