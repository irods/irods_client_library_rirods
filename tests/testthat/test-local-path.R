test_that("files can be chunked", {

  # test object to be split
  x <- matrix(1:100)

  # chunk object from raw vector
  chunks <- chunk_object(serialize(x, NULL), 10L)

  # reversed operation
  xc <- fuse_object(chunks[[1]])
  y <- unserialize(xc)

  expect_equal(x, y)
})

test_that("chunk size can be calculated",{
  expect_snapshot(calc_chunk_size(11, 10L))
  expect_snapshot(calc_chunk_size(20, 10L))
  expect_snapshot(calc_chunk_size(30, 10L))
  expect_error(calc_chunk_size(0, 20L))
})
