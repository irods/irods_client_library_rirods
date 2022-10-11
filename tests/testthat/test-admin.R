test_that("compare shell with R solution", {
  # curl in shell
  shell <- system(system.file(package = "rirods2", "src", "admin.sh"))
  # curl in R
  auth()
  R <- iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
  expect_equal(R, shell)
})
