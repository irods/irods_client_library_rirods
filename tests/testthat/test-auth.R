test_that("compare shell with R solution", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  # curl in shell
  shell <- system2(
    system.file(package = "rirods", "bash", "iauth.sh"),
    c(user, pass, host),
    stdout = TRUE,
    stderr = FALSE
  )

  # curl in R
  R <- get_token(paste0(user, ":", pass), host)

  expect_equal(nchar(R), nchar(shell))
})
