test_that("write stops by local file", {
  # currently mocking does not work for parallel perform
  skip_if(.rirods$token == "secret", "IRODS server unavailable")
  expect_error(stop_local_overwrite(FALSE, "dfr.csv"))
})
