function (response) {
  # mask host in headers
  response$url <- gsub(rirods:::find_irods_file("host"), "", response$url, fixed = TRUE)

  # change body upon error
  if (length(response) == 5 && httr2::resp_is_error(response) && httr2::resp_status(response) >= 400L) {
    within_body_text(response, function(x) gsub(".", "", x))
  } else {
    response
  }
}
