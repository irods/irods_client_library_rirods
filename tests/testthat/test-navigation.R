with_mock_dir("navigation", {
  test_that("navigation works", {

    def_path <- paste0(lpath, "/", user)
    dev_path <- paste0(def_path, "/testthat")
    proj_path <- paste0(def_path, "/projectx")

    # default dir
    expect_invisible(icd("."))
    expect_equal((icd(".")), ipwd()) # icd invisibly returns same as ipwd
    expect_equal(ipwd(), dev_path)

    # go back on level lower
    expect_invisible(icd(".."))
    expect_equal(ipwd(), def_path)

    # relative paths work as well
    expect_invisible(icd("testthat"))
    expect_equal(ipwd(), dev_path)

    icd("..") # move back to execute following test

    # relative paths work as well (in place dot)
    expect_invisible(icd("./testthat"))
    expect_equal(ipwd(), dev_path)

    # relative path in the same parent
    expect_invisible(icd("../projectx"))
    expect_equal(ipwd(), proj_path)

    # test object
    test <- 1
    isaveRDS(test, "test.rds", overwrite = TRUE) # set to `TRUE` in case of test failures
    # error when selecting file instead of collection
    expect_error(icd(paste0(proj_path, "/test.rds")))
    # or for typos and permissions errors
    expect_error(icd(paste0(def_path , "/projecty")))

    # whether trailing slash are removed
    expect_invisible(icd("."))
    expect_equal(ipwd(), proj_path)
    expect_gt(nrow(as.data.frame(ils())), 0)
    expect_invisible(icd("./"))
    expect_equal(ipwd(), proj_path)
    expect_gt(nrow(as.data.frame(ils())), 0)

    # clean-up
    irm(paste0(proj_path, "/test.rds"), force = TRUE)

    # return to default path
    icd(dev_path)

  })
})

with_mock_dir("ils", {
  test_that("ils works", {
    # ils
    icd("..") # move back to execute following test
    expect_gt(nrow(as.data.frame(ils())), 0)
    expect_output(print(ils("projectx")),
                  "This collection does not contain any objects or collections.")
    expect_output(print(ils("/tempZone/home/rods/projectx")),
                  "This collection does not contain any objects or collections.")
    expect_error(ils("tempZone/home/rods/projectx"))
    expect_error(ils("/projectx"))
    icd("testthat") # move back up to testthat
  })
})

test_that("shell equals R solution", {

  # currently mocking does not work
  skip_if(.rirods$token == "secret", "IRODS server unavailable")

  def_path <- paste0(lpath, "/", user)

  # curl in shell
  shell <- system2(
    system.file(package = "rirods", "shell_scripts", "ils.sh"),
    c(user, pass, host, def_path, 0, 0, 0, 0, 100),
    stdout = TRUE,
    stderr = FALSE
  ) |>
    jsonlite::fromJSON()

  # curl in R
  R <- ils(def_path)
  expect_equal(R, rirods:::new_irods_df(shell$`_embedded`))
})
