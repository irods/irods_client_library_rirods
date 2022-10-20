test_that("compare shell with R solution", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  # curl in shell
  shell <- system(system.file(package = "rirods2", "bash", "iadmin.sh"))
  # curl in R
  R <- iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
  expect_equal(R, shell)

  # remove user bobby
  iadmin(action = "remove", target = "user", arg2 = "bobby")
})

