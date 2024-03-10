with_mock_dir("authentication", {
  test_that("authentication errors in absence of configuration", {
    # store conf file
    tmp <- tempfile()
    file.copy(path_to_irods_conf(), tmp)
    unlink(path_to_irods_conf())
    expect_error(iauth(user, pass, "rodsuser"))
    # restore conf file
    file.copy(tmp, path_to_irods_conf())
    expect_type(find_irods_file(), "list")
  })
})

test_that("is there a connection to iRODS", {
  expect_true(is_connected_irods())
})

test_that("token can be retrieved", {
  skip_on_cran()
  skip_on_ci()
  skip_if(!is_irods_demo_running(), "Only for interactive testing.")
  expect_type(get_token(user, pass, host), "character")
})
