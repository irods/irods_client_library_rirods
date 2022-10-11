
iput <- function(
    host = "http://localhost/irods-rest/0.9.2",
    path = "/tempZone/home",
    file,
    offset = 0
) {

  token <- local(token, envir = .rirods2)
  name <- deparse(substitute(file))

  # temp file
  tmp <- tempfile(name, fileext = ".RDS")
  saveRDS(file, tmp)

  req <- httr2::request(host) |>
    httr2::req_url_path_append("stream") |>
    # httr2::req_options() |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_body_file(tmp) |>
    httr2::req_url_query(
      `logical-path` = file.path(path, name),
      offset = offset
    ) |>
    httr2::req_method("PUT")

  # response
  httr2::req_perform(req)

}


iget  <- function(
    host = "http://localhost/irods-rest/0.9.2",
    file = "/tempZone/home",
    path = ".",
    offset = 0,
    count = 1000
) {

  token <- local(token, envir = .rirods2)

  req <- httr2::request(host) |>
    httr2::req_url_path_append("stream") |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_query(
      `logical-path` = file,
      offset = offset,
      count = count
    )

  # response
  resp <- httr2::req_perform(req) |>
    httr2::resp_body_raw()

  con <- rawConnection(resp)
  readRDS(gzcon(con))

}
