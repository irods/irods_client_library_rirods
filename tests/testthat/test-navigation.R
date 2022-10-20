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
  })
})

test_that("compare shell with R solution", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  # curl in shell
  shell <- system(system.file(package = "rirods2", "bash", "ils.sh"), intern = TRUE) |>
    jsonlite::fromJSON()
  # curl in R
  R <- ils(path = "/tempZone/home")
  expect_equal(R, shell$`_embedded`)
})
