with_mock_dir("small-data-objects", {
  test_that("external small data-objects management works", {

    # I use the argument overwrite = TRUE here so that the
    # call to the list REST API is omitted. This omits an additional snapshot
    # for this REST call that is not the purpose of this test.

    #---------------------------------------------------------------------------
    # store small objects in iRODS
    #---------------------------------------------------------------------------
    # R objects
    expect_invisible(isaveRDS(dfr, "dfr.rds",  overwrite = TRUE))
    expect_equal(dfr, ireadRDS("dfr.rds",  overwrite = TRUE))
    expect_invisible(irm("dfr.rds", force = TRUE))
    # external files
    expect_invisible(iput("dfr.csv", "dfr.csv",  overwrite = TRUE))
    expect_invisible(iget("dfr.csv", "dfr.csv", overwrite = TRUE))
    expect_equal(dfr, read.csv("dfr.csv"))
    expect_invisible(irm("dfr.csv", force = TRUE))
    unlink("dfr.csv")
  })
},
simplify = FALSE
)

with_mock_dir("large-data-objects", {
  test_that("external large data-objects management works", {
    # --------------------------------------------------------------------------
    # store large objects in iRODS
    # --------------------------------------------------------------------------
    # R objects
    expect_invisible(isaveRDS(mt, "mt.rds",  overwrite = TRUE))
    expect_equal(mt, ireadRDS("mt.rds",  overwrite = TRUE))
    expect_invisible(irm("mt.rds", force = TRUE))
    # external files
    expect_invisible(iput("mt.csv", "mt.csv", overwrite = TRUE))
    expect_equal(file.size("mt.csv"), ils(stat = TRUE)$status_information$size)
    expect_invisible(iget("mt.csv", "mt.csv", overwrite = TRUE))
    expect_invisible(irm("mt.csv", force = TRUE))
  })
},
simplify = FALSE
)

with_mock_dir("overwrite-data-objects-errors", {
  test_that("overwrite error works", {

    # save file on iRODS
    expect_no_error(
      iput(
        local_path = "foo.csv",
        logical_path = "foo.csv",
        overwrite = TRUE
      )
    )

    # overwrite error on iRODS
    expect_error(
      iput(
        local_path = "foo.csv",
        logical_path = "foo.csv"
      ),
      "Set `overwrite = TRUE`"
    )

    # overwrite error locally
    expect_error(
      iget(
        logical_path = "foo.csv",
        local_path = "foo.csv"
      ),
      "Set `overwrite = TRUE`"
    )

    expect_invisible(irm("foo.csv", force = TRUE))
  })
},
simplify = FALSE
)
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
