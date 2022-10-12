test_that("compare shell with R solution", {
  # curl in shell
  shell <- system(system.file(package = "rirods2", "bash", "auth.sh"), intern = TRUE)
  # curl in R
  R <- get_token()
  expect_equal(nchar(R), nchar(shell))
})
