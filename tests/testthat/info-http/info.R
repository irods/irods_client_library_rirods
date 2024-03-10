structure(list(method = "GET", url = "/info", status_code = 200L, 
    headers = structure(list(Server = "irods_http_api/0.2.0 (8da6c5794f04edab1290e429a0d1676e4452dd5c)", 
        `Content-Type` = "application/json", `Content-Length` = "281", 
        Date = ""), class = "httr2_headers"), body = charToRaw("{\"api_version\":\"0.2.0\",\"build\":\"8da6c5794f04edab1290e429a0d1676e4452dd5c\",\"genquery2_enabled\":true,\"irods_zone\":\"tempZone\",\"max_number_of_parallel_write_streams\":3,\"max_number_of_rows_per_catalog_query\":15,\"max_size_of_request_body_in_bytes\":8388608,\"openid_connect_enabled\":false}"), 
    request = structure(list(url = "http://localhost:9001/irods-http-api/0.2.0/info", 
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
