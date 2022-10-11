test_that("comparer shell with R solution", {
  # curl in shell
  shell <- system(system.file(package = "rirods2", "src", "ils.sh"), intern = TRUE) |>
    jsonlite::fromJSON()
  # curl in R
  auth()
  R <- ils()
  expect_equal(R, shell$`_embedded`)
})
