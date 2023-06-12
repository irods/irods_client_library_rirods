test_that("is there a connection to irods", {
  expect_true(is_connected_irods())
})

test_that("get information about irods server", {
  expect_equal(find_irods_file("host"), host)
  expect_equal(find_irods_file("zone_path"), lpath)
})

test_that("error on finding irods server information", {
  unlink("testthat.irods")
  expect_error(find_irods_file("host"))
  expect_error(find_irods_file("zone_path"))
  create_irods(host, lpath, overwrite = TRUE)
})
