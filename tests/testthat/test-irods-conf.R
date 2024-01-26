with_mock_dir("server-info", {
  test_that("server infor can be obtained", {
   server_info <- get_server_info()
   expect_type(server_info, "list")
  })
})

test_that("get information about iRODS server", {
  expect_true(has_irods_conf())
  expect_equal((check_irods_conf()), path_to_irods_conf())
  expect_equal(path_to_irods_conf(),
               file.path(rappdirs::user_config_dir("rirods"), "conf-irods.json"))
  expect_equal(find_irods_file("host"), host)
  expect_equal(find_irods_file("irods_zone"),  sub("/", "", dirname(dirname(def_path))))
})

test_that("error on finding iRODS server information", {
  # store conf file
  tmp <- tempfile()
  file.copy(path_to_irods_conf(), tmp)
  unlink(path_to_irods_conf())
  expect_false(has_irods_conf())
  expect_error(check_irods_conf())
  expect_error(find_irods_file("host"))
  expect_error(find_irods_file("irods_zone"))
  # restore conf file
  file.copy(tmp, path_to_irods_conf())
})
