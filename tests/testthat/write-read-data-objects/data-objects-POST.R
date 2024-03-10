structure(list(method = "POST", url = "/data-objects", status_code = 200L, 
    headers = structure(list(Server = "irods_http_api/0.2.0 (8da6c5794f04edab1290e429a0d1676e4452dd5c)", 
        `Content-Type` = "application/json", `Content-Length` = "36", 
        Date = ""), class = "httr2_headers"), body = charToRaw("{\"irods_response\":{\"status_code\":0}}"), 
    request = structure(list(url = "http://localhost:9001/irods-http-api/0.2.0/data-objects", 
        method = "POST", headers = structure(list(Authorization = ""), redact = "Authorization"), 
        body = list(data = list(op = "write", lpath = "/tempZone/home/rods/testthat/dfr.csv", 
            offset = "0", truncate = "1", append = "0", bytes = structure(list(
                value = as.raw(c(0x61, 0x2c, 0x62, 0x2c, 0x63, 
                0x0a, 0x61, 0x2c, 0x31, 0x2c, 0x36, 0x0a, 0x62, 
                0x2c, 0x32, 0x2c, 0x37, 0x0a, 0x63, 0x2c, 0x33, 
                0x2c, 0x38, 0x0a)), type = "application/octet-stream"), class = "form_data")), 
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
