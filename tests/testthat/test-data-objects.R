test_that("external data-objects management works", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  # some data
  foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

  # creates a csv file of foo
  readr::write_csv(foo, "foo.csv")

  # store
  expect_invisible(iput("foo.csv"))
  # overwrite error
  expect_error(iput("foo.csv"))
  # solve overwrite
  expect_invisible(iput("foo.csv", overwrite = TRUE))

  # retrieve object
  expect_snapshot(iget("foo.csv", overwrite = TRUE))

  # remove object
  expect_invisible(irm("foo.csv"))

  # garbage collect
  unlink("foo.csv")
})

# test_that("shell equals R solution", {
#
#   # this can not be accommodated by httptest2
#   skip_if_offline()
#   skip_if(inherits(tk, "try-error"))
#
#   # curl in shell
#   system2(
#     system.file(package = "rirods", "bash", "iput.sh"),
#     stdout = NULL,
#     stderr = NULL
#   )
#
#   shell <- utils::object.size(iget("/tempZone/home/rods/foo"))
#
#   # some data
#   foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#
#   # store
#   iput(foo, path = "/tempZone/home/rods", overwrite = TRUE)
#
#   R <- utils::object.size(iget("/tempZone/home/rods/foo"))
#
#   expect_equal(shell, R)
#
#   # remove object
#   expect_invisible(irm("/tempZone/home/rods/foo"))
# })
#
