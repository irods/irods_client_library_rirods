test_that("compare shell with R solution", {

  # curl in shell
  system(system.file(package = "rirods2", "src", "iput.sh"))

  # curl in R
  auth()

  shell <- utils::object.size(iget(file = "/tempZone/home/rods/foo"))

  # some data
  foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
  # store
  iput(file = foo, path = "/tempZone/home/rods")

  R <- utils::object.size(iget(file = "/tempZone/home/rods/foo"))

  expect_equal(shell, R)
})
