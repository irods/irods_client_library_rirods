with_mock_dir("data-objects", {
  test_that("external data-objects management works", {

    # store
    expect_invisible(iput("foo.csv"))

    # retrieve object
    iget("foo.csv", overwrite = TRUE)
    expect_equal(read.csv("foo.csv"), foo)

    # remove object
    expect_invisible(irm("foo.csv"))
  })
},
simplify = FALSE
)

test_that("overwrite error works", {

  # overwrite error on irods
  test <- "test"
  expect_error(
    iput(
      test,
      path = paste0(lpath, "/", user, "/testthat")
    )
  )

  # overwrite error locally
  test_file <- tempfile(fileext = ".csv")
  expect_error(iget(basename(test_file), path = dirname(test_file)))

})

# test_that("shell equals R solution", {
#
#   # this can not be accommodated by httptest2
#   skip_if_offline()
#   skip_if(inherits(tk, "try-error"))
#
#   # curl in shell
# system2(
#   system.file(package = "rirods", "bash", "iput.sh"),
#   c(Sys.getenv("DEV_USER"), Sys.getenv("DEV_PASS"), Sys.getenv("DEV_HOST_IRODS"), paste0(Sys.getenv("DEV_ZONE_PATH_IRODS"), "/rods"), 0),
#   stdout = NULL,
#   stderr = NULL
# )
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
