test_that("compare shell with R solution", {

  # create test fixture
  local_create_irods()

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

