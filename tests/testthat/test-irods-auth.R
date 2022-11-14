test_that("is there a connection to irods", {
  expect_true(is_connected_irods())
})

test_that("get information about irods sever", {
  expect_equal(find_irods_file("host"), host)
  expect_equal(find_irods_file("zone_path"), lpath)
})
