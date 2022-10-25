with_mock_dir("navigation", {
  test_that("navigation works", {

    # default dir
    expect_invisible(icd("."))
    expect_snapshot(ipwd())

    # some other dir
    expect_invisible(icd("/tempZone/home"))
    expect_snapshot(ipwd())

    # go back on level lower
    expect_invisible(icd(".."))
    expect_snapshot(ipwd())

    # relative paths work as well
    expect_invisible(icd("../home/public"))
    expect_snapshot(ipwd())

    # error when selecting file instead of collection
    expect_error(icd("/tempZone/home/bobby/test"))
    # or for typos and permissions errors
    expect_error(icd("tempZone/home/frank"))

  })
})

test_that("shell equals R solution", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  # curl in shell
  shell <- system(
    system.file(package = "rirods", "bash", "ils.sh"),
    ignore.stderr = TRUE,
    intern = TRUE
  ) |>
    jsonlite::fromJSON()

  # curl in R
  R <- ils(path = "/tempZone/home")
  expect_equal(R, shell$`_embedded`)
})
