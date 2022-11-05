with_mock_dir("navigation", {
  test_that("navigation works", {

    def_path <- paste0(lpath, "/", user)
    dev_path <- paste0(def_path, "/testthat")
    proj_path <- paste0(def_path, "/projectx")

    # default dir
    expect_invisible(icd("."))
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

    # error when selecting file instead of collection
    expect_error(icd(paste0(dev_path, "/test")))
    # or for typos and permissions errors
    expect_error(icd(paste0(def_path , "/projecty")))

    # return to default path
    icd("../testthat")

  })
})

test_that("shell equals R solution", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  def_path <- paste0(lpath, "/", user)

  # curl in shell
  shell <- system2(
    system.file(package = "rirods", "bash", "ils.sh"),
    c(user, pass, host, def_path, 0, 0, 0, 0, 100),
    stdout = TRUE,
    stderr = FALSE
  ) |>
    jsonlite::fromJSON()

  # curl in R
  R <- ils(path = def_path)
  expect_equal(R, shell$`_embedded`)
})
