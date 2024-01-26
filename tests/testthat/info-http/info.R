structure(list(method = "GET", url = "/info", status_code = 200L, 
    headers = structure(list(Server = "irods_http_api/0.1.0 [86bad75c3dc6e8f8855a5978bfa43c79f069101c]", 
        `Content-Type` = "application/json", `Content-Length` = "247", 
        Date = ""), class = "httr2_headers"), body = charToRaw("{\"api_version\":\"0.1.0\",\"build\":\"86bad75c3dc6e8f8855a5978bfa43c79f069101c\",\"genquery2_enabled\":true,\"irods_zone\":\"tempZone\",\"max_http_request_size_in_bytes\":8388608,\"max_number_of_parallel_write_streams\":3,\"max_number_of_rows_per_catalog_query\":15}"), 
    request = structure(list(url = "http://localhost:9001/irods-http-api/0.1.0/info", 
        method = "GET", headers = structure(list(Authorization = ""), redact = "Authorization"), 
        body = NULL, fields = list(), options = list(), policies = list(
            retry_max_tries = 3, retry_is_transient = structure(function (..., 
                .x = ..1, .y = ..2, . = ..1) 
            httr2::resp_status(.x) %in% c(429, 503), class = c("rlang_lambda_function", 
            "function")), error_body = function (resp) 
            {
                if (httr2::resp_status(resp) >= 500 && httr2::resp_status(resp) < 
                  600) {
                  irods_message <- try(httr2::resp_body_json(resp, 
                    check_type = TRUE)$error_message, silent = TRUE)
                  paste0(ifelse(inherits(irods_message, "try-error"), 
                    "", irods_message), "The iRODS server might be malconfigured.")
                }
                else if (length(resp$body) != 0) {
                  resp <- unlist(httr2::resp_body_json(resp, 
                    check_type = FALSE))
                  paste(names(resp), vapply(resp, as.character, 
                    character(1)), sep = ": ")
                }
                else {
                  "This is likely a malformed HTTP request."
                }
            })), class = "httr2_request"), cache = new.env(parent = emptyenv())), class = "httr2_response")
