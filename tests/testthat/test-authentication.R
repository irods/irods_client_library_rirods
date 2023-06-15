test_that("authentication errors in absence of configuration", {
  unlink(path_to_irods_conf())
  expect_error(iauth(user, pass, "rodsuser"))
  create_irods(host, lpath, overwrite = TRUE)
})

test_that("is there a connection to iRODS", {
  expect_true(is_connected_irods())
})

test_that("compare shell with R solution", {

  # currently mocking does not work
  skip_if(.rirods$token == "secret", "IRODS server unavailable")

  # curl in shell
  shell <- system2(
    system.file(package = "rirods", "shell_scripts", "iauth.sh"),
    c(user, pass, host),
    stdout = TRUE,
    stderr = FALSE
  )

  # curl in R
  R <- rirods:::get_token(paste0(user, ":", pass), host)

  expect_equal(nchar(R), nchar(shell))
})
