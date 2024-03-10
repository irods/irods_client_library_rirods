function (response) {

  grep_json_body_element <- function(response, element) {
    response_R_body <- jsonlite::fromJSON(rawToChar(response$body))
    response_R_body[[element]] <- character(1)
    response$body <- charToRaw(jsonlite::toJSON(response_R_body,  auto_unbox = TRUE))
    response
  }

  # mask host in headers
  response$url <- gsub(rirods:::find_irods_file("host"), "", response$url, fixed = TRUE)

  # mask dates in headers
  response$headers$Date <- ""

  if (inherits(response, "httr2_response")) {
    if (grepl("op=stat", response$request$url)) {
      response <- grep_json_body_element(response, "modified_at") # stat
    }
    if (response$method == "GET" && grepl("query", response$url) && grepl("CREATE_TIME", response$url)) {
      # response <- grep_json_body_element(response, "rows") needs refinement
    }
    is_body_data_operation <- response$request$body$data$op
    if (!is.null(is_body_data_operation)) {
      if (response$method != "GET" && is_body_data_operation == "parallel_write_init") {
        response <- grep_json_body_element(response, "parallel_write_handle") # mask token for init and shutdown
      }
      if (response$method != "GET" && is_body_data_operation == "parallel_write_shutdown") {
        response$request$body$data$`parallel-write-handle` <- character(1)
      }
    }
    response$request$headers$Authorization  <- "" # token
  }

  if (inherits(response, "httr2_request")) {
    is_body_data_operation <- response$body$data$op
    if (!is.null(is_body_data_operation)) {
      if (inherits(response$body$data$bytes,  "form_data")) {
        # change body upon PUT when type is raw (`iput()` and `isaverds()`)
        response$body$data <- NULL
      } else if (response$method != "GET" && is_body_data_operation == "parallel_write_shutdown") {
        response$body$data$`parallel-write-handle` <- character(1)
      }
    }
  }

  response
}


