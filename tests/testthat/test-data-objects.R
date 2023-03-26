with_mock_dir("data-objects", {
  test_that("external data-objects management works", {

    # I use the argument overwrite = TRUE here so that the
    # call to the list REST API is omitted. This omits an additional snapshot
    # for this REST call that is not the purpose of this test.

    # currently mocking does not work
    skip_if(.rirods$token == "secret", "IRODS server unavailable")

    # small dataset
    dfr <- data.frame(a = c("a", "b", "c"), b = 1:3, c = 6:8)
    expect_invisible(isaveRDS(dfr, "dfr.rds",  overwrite = TRUE))
    expect_equal(dfr, ireadRDS("dfr.rds",  overwrite = TRUE))
    expect_invisible(irm("dfr.rds"))

    # large dataset (about two times default count of 2000)
    mt <- matrix(1:940, 94, 10)
    expect_invisible(isaveRDS(mt, "mt.rds", overwrite = TRUE))
    expect_equal(mt, ireadRDS("mt.rds"))
    expect_invisible(irm("mt.rds"))

    # store file
    expect_invisible(iput("foo.csv", overwrite = TRUE))

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
#   # currently mocking does not work
#   skip_if(.rirods$token == "secret", "IRODS server unavailable")
#
#   # curl in shell
#   system2(
#     system.file(package = "rirods", "bash", "iput.sh"),
#     c(user, pass, host, paste0(def_path, "/testthat") , 0, 8192L),
#     stdout = NULL,
#     stderr = NULL
#   )
#
#   # get back from shell
#   system2(
#     system.file(package = "rirods", "bash", "iget.sh"),
#     c(user, pass, host, paste0(def_path, "/testthat/foo.rds") , 0, 8192L),
#     stdout = NULL,
#     stderr = NULL
#   )
#
#   # get shell put object
#   shell <- readRDS("foo.rds")
#   expect_equal(shell, foo)
#
#   # remove file
#   unlink("foo.rds")
#
#   # remove object
#   expect_invisible(irm(paste0(def_path, "/testthat/foo.rds")))
# })
