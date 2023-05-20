with_mock_dir("irods-rest-call", {
  test_that("irods rest call works", {

    # flags to curl call
    args <- list(
      `logical-path` = paste0(lpath, "/", user, "/testthat"),
      stat = 1,
      permissions = 1,
      metadata = 1,
      offset = 0,
      limit = 100
    )

    # with a httr response
    expect_s3_class(
      irods_rest_call("list", "GET", args, FALSE),
      "httr2_response"
    )

  })
})

test_that("data switch works", {

  # currently mocking does not work
  skip_if(.rirods$token == "secret", "IRODS server unavailable")

  req <- httr2::request(find_irods_file("host")) |>
    httr2::req_url_path_append("stream") |>
    httr2::req_headers(Authorization = local(token, envir = .rirods)) |>
    httr2::req_method("PUT")

  object <- charToRaw("object")
  expect_equal(data_switch("object", req, object)$url, paste0(host,"/stream"))

})
