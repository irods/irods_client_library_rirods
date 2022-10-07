test_that("compare shell with R solution", {
  shell <- system(system.file(package = "rirods2", "src", "admin.sh"))
  R <- riadmin(token = get_token(), action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
  expect_equal(R, shell)
})
