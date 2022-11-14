test_that("warm about potential overwrite", {

  expect_error(stop_local_overwrite(FALSE, "testthat.irods"))
})

test_that("files can be chunked", {

  # chunk file
  fm <- chunk_file("baz.rds", 3000L)

  # reversed operation
  xc <- Map(
    function(x, y) {
      con <- file(x, "rb")
      on.exit(close(con))
      readBin(con, "raw", y)
    },
    fm[[1]],
    fm[[3]]
    )
  xc <- fuse_file(xc)
  con <- rawConnection(xc)

  expect_equal(readRDS(gzcon(con)), readRDS("baz.rds"))
  close(con)
})

