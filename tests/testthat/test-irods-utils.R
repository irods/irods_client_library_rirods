test_that("maxamimum number of rows query can be changed by user", {
  expect_equal(
    maximum_number_of_rows_catalog(16),
    find_irods_file("max_number_of_rows_per_catalog_query")
  )
  expect_equal(
    maximum_number_of_rows_catalog(2),
    2L
  )
})

test_that("maxamimum number of rows returned irods_df can be changed by user", {
  ref <- structure(
    list(
      logical_path = paste0(irods_test_path, "/", c("dfr.csv", "new", "new2"))
    ),
    row.names = 1:3,
    class = "data.frame"
  )
  expect_equal(
    nrow(as.data.frame(limit_maximum_number_of_rows_catalog(ref, 2L))),
    2L
  )
  ref <- structure(
    list(),
    row.names = 0L,
    class = "data.frame"
  )
  expect_equal(
    nrow(as.data.frame(limit_maximum_number_of_rows_catalog(ref, 1L))),
    1L
  )
  expect_error(limit_maximum_number_of_rows_catalog(data.frame()))
})
