test_that("compare shell with R solution", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  # curl in shell
  system(system.file(package = "rirods2", "bash", "iput.sh"))

  shell <- utils::object.size(iget("/tempZone/home/rods/foo"))

  # some data
  foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

  # store
  iput(foo, path = "/tempZone/home/rods")

  R <- utils::object.size(iget("/tempZone/home/rods/foo"))

  expect_equal(shell, R)
})

