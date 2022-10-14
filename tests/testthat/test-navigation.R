with_mock_dir("navigation", {
  test_that("navigation works", {

    iauth()

    # default dir
    expect_snapshot(icd("."))
    expect_snapshot(ipwd())

    # some other dir
    expect_snapshot(icd("/tempZone/home"))
    expect_snapshot(ipwd())

    # go back on level lower
    expect_snapshot(icd(".."))
    expect_snapshot(ipwd())

    # relative paths work as well
    expect_snapshot(icd("../home/public"))
    expect_snapshot(ipwd())
  })
})

test_that("compare shell with R solution", {

  iauth()

  # curl in shell
  shell <- system(system.file(package = "rirods2", "bash", "ils.sh"), intern = TRUE) |>
    jsonlite::fromJSON()
  # curl in R
  R <- ils(path = "/tempZone/home")
  expect_equal(R, shell$`_embedded`)
})
