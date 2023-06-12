with_mock_dir("metadata-1", {
  test_that("metadata works 1" , {

    # test object
    test <- 1
    isaveRDS(test, "test.rds", overwrite = TRUE) # set to `TRUE` in case of test failures

    # single
    imeta(
      "test.rds",
      "data_object",
      operations =
        list(list(operation = "add", attribute = "foo", value = "bar", units = "baz"))
    )

    # reference `dataframe`
    ref <- structure(
      list(
        logical_path = paste0(lpath, "/", user, "/testthat/test.rds"),
        metadata = list(structure(
          list(
            attribute = "foo",
            value = "bar",
            units = "baz"
          ),
          row.names = c(NA, -1L),
          class = "data.frame"
        )),
        type = "data_object"
      ),
      row.names = c(NA,-1L),
      class = "irods_df"
    )

    expect_equal(ils(metadata = TRUE), ref)

  })
})

with_mock_dir("metadata-2", {
  test_that("metadata works 2" , {

    # double
    imeta(
      "test.rds",
      "data_object",
      operations =
        list(
          list(operation = "add", attribute = "foo", value = "bar", units = "baz"),
          list(operation = "add", attribute = "foo2", value = "bar2", units = "baz2")
        )
    )

    # reference dataframe
    ref <- structure(list(
      logical_path = paste0(lpath, "/", user, "/testthat/test.rds"),
      metadata = list(
        structure(
          list(attribute = c("foo", "foo2"), value = c("bar", "bar2"), units = c("baz", "baz2")),
          row.names = c(1L, 2L),
          class = "data.frame"
          )
        ),
      type = "data_object"
    ),
    row.names = c(NA, -1L),
    class = "irods_df"
    )

    expect_equal(ils(metadata = TRUE), ref)

  })
})

with_mock_dir("metadata-3", {
  test_that("metadata works 3" , {
    # In this check we address Issue #23:
    # "Metadata columns in wrong order when some item has no metadata"

    # For this we need a second `data_object`, but for the rest the test is the
    # same as above "metadata works 2".
    some_object <- 1:10
    isaveRDS(some_object, "some_object.rds", overwrite = TRUE)

    imeta(
      "test.rds",
      "data_object",
      operations =
        list(
          list(operation = "add", attribute = "foo", value = "bar", units = "baz"),
          list(operation = "add", attribute = "foo2", value = "bar2", units = "baz2")
        )
    )

    # reference `data.frame`
    ref <- structure(
      list(
      logical_path = c(
        paste0(lpath, "/", user, "/testthat/some_object.rds"),
        paste0(lpath, "/", user, "/testthat/test.rds")
      ),
      metadata = list(
        structure(
          list(),
          names = character(0),
          row.names = integer(0),
          class = "data.frame"
        ),
        structure(
          list(
            attribute = c("foo", "foo2"),
            value = c("bar", "bar2"),
            units = c("baz", "baz2")
          ),
          row.names = c(1L, 2L),
          class = "data.frame"
        )
      ),
      type = c("data_object", "data_object")
    ),
    row.names = c(1L, 2L),
    class = "irods_df"
    )

    expect_equal(ils(metadata = TRUE), ref)

    irm("some_object.rds", force = TRUE)
  })
})

with_mock_dir("metadata-errors", {
  test_that("metadata errors" , {
    # In this check we address Issue #23:
    # "The code would check and force that operations is a list of lists"

    error_type1  <- c("x") # type error
    error_msg1 <- "The supplied `operations` should be of type `list` or `data.frame`."

    expect_error(imeta("test.rds", operation =  error_type1), error_msg1)

    error_type2  <- list("x") # type error
    error_msg2 <- "The supplied list of `operations` should contain a named `list`."

    expect_error(imeta("test.rds", operation =  error_type2), error_msg2)

    error_names1 <- list(list(x=1)) # naming error
    error_names2 <- data.frame(x=1) # naming error
    error_msg3 <- "The supplied `operations` should have names that can include \"operation\", \"attribute\", \"value\", \"units\"."

    expect_error(imeta("test.rds", operation =  error_names1), error_msg3)
    expect_error(imeta("test.rds", operation =  error_names2), error_msg3)

    error_content <- list(list(operation = "modify"))
    error_msg4 <- "The element \"operation\" of `operations` can contain \"add\" or \"remove\"."
    expect_error(imeta("test.rds", operation =  error_content), error_msg4)
  })
})

with_mock_dir("metadata-query", {
  test_that("metadata query works" , {

    # reference dataframe
    ref <- c(
      paste0(lpath, "/", user, "/testthat"),
      "test.rds"
    ) |> matrix(ncol = 2)

    # query
    iq <- iquery(
      paste0("SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '", lpath, "/%'")
    )

    expect_equal(iq, ref)

  })
})

with_mock_dir("metadata-remove", {
  test_that("metadata removing works" , {

    # remove metadata
    imeta(
      "test.rds",
      "data_object",
      operations =
        list(
          list(operation = "remove", attribute = "foo", value = "bar", units = "baz"),
          list(operation = "remove", attribute = "foo2", value = "bar2", units = "baz2")
        )
    )

    # reference dataframe
    ref <- structure(list(
      logical_path = paste0(lpath, "/", user, "/testthat/test.rds"),
      metadata = list(list()),
      type = "data_object"
    ),
    row.names = c(NA, -1L),
    class = "irods_df"
    )

    expect_equal(ils(metadata = TRUE), ref)

    # clean-up
    irm("test.rds", force = TRUE)

  })
})
