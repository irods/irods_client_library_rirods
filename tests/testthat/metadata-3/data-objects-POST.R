structure(list(method = "POST", url = "/data-objects", status_code = 200L, 
    headers = structure(list(Server = "irods_http_api/0.2.0 (8da6c5794f04edab1290e429a0d1676e4452dd5c)", 
        `Content-Type` = "application/json", `Content-Length` = "36", 
        Date = ""), class = "httr2_headers"), body = charToRaw("{\"irods_response\":{\"status_code\":0}}"), 
    request = structure(list(url = "http://localhost:9001/irods-http-api/0.2.0/data-objects", 
        method = "POST", headers = structure(list(Authorization = ""), redact = "Authorization"), 
        body = list(data = list(op = "write", lpath = "/tempZone/home/rods/testthat/some_object.rds", 
            offset = "0", truncate = "1", append = "0", bytes = structure(list(
                value = as.raw(c(0x58, 0x0a, 0x00, 0x00, 0x00, 
                0x03, 0x00, 0x04, 0x03, 0x03, 0x00, 0x03, 0x05, 
                0x00, 0x00, 0x00, 0x00, 0x05, 0x55, 0x54, 0x46, 
                0x2d, 0x38, 0x00, 0x00, 0x00, 0xee, 0x00, 0x00, 
                0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 
                0x00, 0x09, 0x00, 0x00, 0x00, 0x0e, 0x63, 0x6f, 
                0x6d, 0x70, 0x61, 0x63, 0x74, 0x5f, 0x69, 0x6e, 
                0x74, 0x73, 0x65, 0x71, 0x00, 0x00, 0x00, 0x02, 
                0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x09, 
                0x00, 0x00, 0x00, 0x04, 0x62, 0x61, 0x73, 0x65, 
                0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x0d, 
                0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0d, 
                0x00, 0x00, 0x00, 0xfe, 0x00, 0x00, 0x00, 0x0e, 
                0x00, 0x00, 0x00, 0x03, 0x40, 0x24, 0x00, 0x00, 
                0x00, 0x00, 0x00, 0x00, 0x3f, 0xf0, 0x00, 0x00, 
                0x00, 0x00, 0x00, 0x00, 0x3f, 0xf0, 0x00, 0x00, 
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfe, 
                0x00)), type = "application/octet-stream"), class = "form_data")), 
            type = "multipart", content_type = NULL, params = list()), 
        fields = list(), options = list(), policies = list(retry_max_tries = 3, 
            retry_is_transient = structure(function (..., .x = ..1, 
                .y = ..2, . = ..1) 
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
