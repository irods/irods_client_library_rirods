test_that("compare shell with R solution", {

  # currently mocking does not work
  skip_if(.rirods$token == "secret", "IRODS server unavailable")

  # curl in shell
  shell <- system2(
    system.file(package = "rirods", "bash", "iauth.sh"),
    c(user, pass, host),
    stdout = TRUE,
    stderr = FALSE
  )

  # curl in R
  R <- rirods:::get_token(paste0(user, ":", pass), host)

  expect_equal(nchar(R), nchar(shell))
})
