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

