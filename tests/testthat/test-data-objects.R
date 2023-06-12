with_mock_dir("data-objects", {
  test_that("external data-objects management works", {

    # I use the argument overwrite = TRUE here so that the
    # call to the list REST API is omitted. This omits an additional snapshot
    # for this REST call that is not the purpose of this test.

    #---------------------------------------------------------------------------
    # store small objects in iRODS
    #---------------------------------------------------------------------------
    dfr <- data.frame(a = c("a", "b", "c"), b = 1:3, c = 6:8)
    # R objects
    expect_invisible(isaveRDS(dfr, "dfr.rds",  overwrite = TRUE))
    expect_equal(dfr, ireadRDS("dfr.rds",  overwrite = TRUE))
    expect_invisible(irm("dfr.rds", force = TRUE))
    # external files
    readr::write_csv(dfr, "dfr.csv")
    expect_invisible(iput("dfr.csv",  overwrite = TRUE))
    expect_invisible(iget("dfr.csv",  overwrite = TRUE))
    expect_equal(dfr, as.data.frame(readr::read_csv("dfr.csv", show_col_types = FALSE)))
    expect_invisible(irm("dfr.csv", force = TRUE))
    unlink("dfr.csv")

    # --------------------------------------------------------------------------
    # store large objects in iRODS
    # --------------------------------------------------------------------------
    mt <- list(1:10000)
    # R objects
    expect_invisible(isaveRDS(mt, "mt.rds",  overwrite = TRUE))
    expect_equal(mt, ireadRDS("mt.rds",  overwrite = TRUE))
    expect_invisible(irm("mt.rds", force = TRUE))
    # external files
    readr::write_csv(as.data.frame(mt), "mt.csv")
    expect_invisible(iput("mt.csv",  overwrite = TRUE))
    expect_equal(file.size("mt.csv"), ils(stat = TRUE)$status_information$size)
    expect_invisible(iget("mt.csv",  overwrite = TRUE))
    expect_invisible(irm("mt.csv", force = TRUE))
    unlink("mt.csv")
    })
},
simplify = FALSE
)

test_that("overwrite error works", {

  # no actual http call is made in these instances

  # overwrite error on iRODS
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
#     system.file(package = "rirods", "shell_scripts", "iput.sh"),
#     c(user, pass, host, paste0(def_path, "/testthat") , 0, 8192L),
#     stdout = NULL,
#     stderr = NULL
#   )
#
#   # get back from shell
#   system2(
#     system.file(package = "rirods", "shell_scripts", "iget.sh"),
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
