test_that("comparer shell with R solution", {
  shell <- system(system.file(package = "rirods2", "src", "ils.sh"), intern = TRUE) |>
    jsonlite::fromJSON()
  R <- rils(token = get_token())
  expect_equal(R, tibble::as_tibble(shell$`_embedded`))
})
