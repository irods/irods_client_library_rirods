test_that("comparer shell with R solution", {
  # curl in shell
  shell <- system(system.file(package = "rirods2", "src", "auth.sh"), intern = TRUE)
  # curl in R
  R <- get_token()
  expect_equal(R, shell)
})
