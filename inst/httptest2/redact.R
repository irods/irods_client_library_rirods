function (response) {

  # mask host in headers
  response$url <- gsub(rirods:::find_irods_file("host"), "", response$url, fixed = TRUE)

  # change body upon PUT when type is raw (`iput()` and `isaverds()`)
  type_body <- try(response$body$type, silent = TRUE)
  if (!inherits(type_body, "try-error") && !is.null(type_body) && type_body == "raw" && response$method == "PUT") {
    response$body$data <- NULL
    response
  # make sure that `ils()` calls that error have no content body
  } else if (length(response) == 5 && httr2::resp_is_error(response) && httr2::resp_status(response) >= 400L) {
    within_body_text(response, function(x) gsub(".", "", x))
  } else {
    response
  }
}
