test_that("write stops by local file", {
  expect_error(stop_local_overwrite(FALSE, "dfr.csv"))
  expect_null(stop_local_overwrite(TRUE, "dfr.csv"))
})
