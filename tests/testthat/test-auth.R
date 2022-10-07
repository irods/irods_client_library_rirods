test_that("comparer shell with R solution", {
  shell <- system(system.file(package = "rirods2", "src", "auth.sh"), intern = TRUE)
  R <- get_token()
  expect_equal(R, shell)
})
