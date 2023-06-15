test_that("get information about iRODS server", {
  expect_true(has_irods_conf())
  expect_equal((check_irods_conf()), path_to_irods_conf())
  expect_equal(
    path_to_irods_conf(),
    file.path(rappdirs::user_config_dir("rirods"), "conf.irods")
  )
  expect_equal(find_irods_file("host"), host)
  expect_equal(find_irods_file("zone_path"), lpath)
})

test_that("error on finding iRODS server information", {
  unlink(path_to_irods_conf())
  expect_false(has_irods_conf())
  expect_error(check_irods_conf())
  expect_error(find_irods_file("host"))
  expect_error(find_irods_file("zone_path"))
  create_irods(host, lpath, overwrite = TRUE)
})
