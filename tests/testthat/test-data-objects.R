with_mock_dir("parallel-write-handle", {
  test_that("parallel write can be started and stopped", {
    parallel_write_handle <- parallel_write_init(
      paste0(irods_test_path, "/x"),
      stream_count = 2,
      truncate = 1,
      append = 0,
      ticket = NULL,
      verbose = FALSE
    )
    expect_type(parallel_write_handle, "character")
    expect_invisible(
      parallel_write_shutdown(parallel_write_handle, verbose = FALSE)
    )
  })
},
simplify = FALSE
)

with_mock_dir("single-write", {
  test_that("single write request works", {
    x <- list()
    object <- serialize(x, NULL)
    offset <- 0
    count <- 150
    truncate <- 1
    append <- 0
    lpath <- paste0(irods_test_path, "/x")
    req <- local_to_irods_(
      object,
      lpath,
      offset,
      count,
      truncate,
      append,
      stream_index = NULL,
      ticket = NULL,
      verbose = FALSE
    )
    expect_s3_class(req, "httr2_request")
    httr2::req_perform(req)
    req <- irods_to_local(lpath, ticket = NULL, verbose = FALSE)
    expect_s3_class(req, "httr2_request")
    con <- rawConnection(raw(0),  "a+b")
    on.exit(close(con))
    resp <- httr2::req_perform(req) |>
      httr2::resp_body_raw()
    writeBin(resp, con, useBytes = TRUE)
    # currently mocking does not work
    if (.rirods$token != "secret") {
      y <- rawConnectionValue(con) |> unserialize()
      expect_equal(y, x)
    }
    test_irm(paste0(irods_test_path, "/x"))
  })
},
simplify = FALSE
)

with_mock_dir("chunked-write", {
  test_that("chunked write request works", {

    # currently mocking does not work for parallel perform
    skip_if(.rirods$token == "secret", "IRODS server unavailable")

    max_number_of_parallel_write_streams <-
      find_irods_file("max_number_of_parallel_write_streams")
    object <- serialize(dfr, NULL) # 400 bytes
    object_size <- length(object)
    count <- 200
    ticket <- NULL
    verbose <- FALSE
    lpath <- paste0(irods_test_path, "/dfr.rds")
    chunks <-
      calc_chunk_size(object_size, count, max_number_of_parallel_write_streams)
    reqs <- chunked_local_to_irods(chunks,
                                   object,
                                   lpath,
                                   truncate = 1,
                                   append = 0,
                                   ticket,
                                   verbose)
    expect_type(reqs, "list")
    expect_type(reqs[[1]], "list")
    resp <- parallel_perform(reqs[[1]], lpath, truncate = 1, append = 0, ticket, verbose)
    expect_type(resp, "list")
    expect_s3_class(resp[[1]], "httr2_response")
    expect_equal(dfr, ireadRDS("dfr.rds"))
    test_irm(paste0(irods_test_path, "/dfr.rds"))
    # serial and parallel
    count <- 50
    chunks <-
      calc_chunk_size(object_size, count, max_number_of_parallel_write_streams)
    reqs <- chunked_local_to_irods(chunks,
                                   object,
                                   lpath,
                                   truncate = 1,
                                   append = 0,
                                   ticket,
                                   verbose)
    resp <- sequential_parallel_perform(reqs, lpath, truncate = 1, append = 0, ticket, verbose)
    expect_type(resp, "list")
    expect_type(resp[[1]], "list")
    expect_s3_class(resp[[1]][[1]], "httr2_response")
    expect_equal(dfr, ireadRDS("dfr.rds"))
    test_irm(paste0(irods_test_path, "/dfr.rds"))
  })
},
simplify = FALSE
)

with_mock_dir("write-from-memory", {
  test_that("write from memory to iRODS", {
    chunks <- local_to_irods(
      dfr,
      paste0(irods_test_path, "/dfr.rds"),
      count = 15,
      ticket = NULL,
      verbose = FALSE
    )
    expect_type(chunks, "list")
    expect_type(chunks[[1]], "list")
    expect_s3_class(chunks[[1]][[1]], "httr2_request")
  })
},
simplify = FALSE
)

with_mock_dir("write-from-disk", {
  test_that("write from disk to iRODS works", {
    x <- file("dfr.csv", "rb", raw = TRUE)
    on.exit(close(x))
    chunks <- local_to_irods(
      x,
      paste0(irods_test_path, "/dfr.csv"),
      count = 15,
      ticket = NULL,
      verbose = FALSE
    )
    expect_type(chunks, "list")
    expect_type(chunks[[1]], "list")
    expect_s3_class(chunks[[1]][[1]], "httr2_request")
  })
},
simplify = FALSE
)

with_mock_dir("write-read-data-objects", {
  test_that("write and read data-objects works", {

    # R objects
    expect_invisible(isaveRDS(dfr, "dfr.rds", overwrite = TRUE)) # overwrite = TRUE to circumvent additional API calls
    # currently mocking does not work for ireadRDS streaming
    if (.rirods$token != "secret") {
      expect_equal(dfr, ireadRDS("dfr.rds"))
    }

    # external files
    expect_invisible(iput("dfr.csv", "dfr.csv", overwrite = TRUE))
    unlink( "dfr.csv")
    expect_invisible(out_path <- iget("dfr.csv",  "dfr.csv"))
    expect_equal(dfr, read.csv(out_path$body))
    write.csv(read.csv(out_path$body), "dfr.csv")

    test_irm(paste0(irods_test_path, "/dfr.csv"))
    test_irm(paste0(irods_test_path, "/dfr.rds"))
  })
},
simplify = FALSE
)

test_that("chunk size can be calculated", {
  max_number_of_parallel_write_streams <-
    find_irods_file("max_number_of_parallel_write_streams")
  expect_snapshot(calc_chunk_size(11, 10L, max_number_of_parallel_write_streams))
  expect_snapshot(calc_chunk_size(20, 10L, max_number_of_parallel_write_streams))
  expect_snapshot(calc_chunk_size(50, 10L, max_number_of_parallel_write_streams))
  expect_error(calc_chunk_size(0, 20L, max_number_of_parallel_write_streams))
})
