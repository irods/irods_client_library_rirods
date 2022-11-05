with_mock_dir("metadata-1", {
  test_that("metadata works 1" , {

    # single
    imeta(
      "test",
      "data_object",
      operations =
        list(operation = "add", attribute = "foo", value = "bar", units = "baz")
    )

    # reference dataframe
    ref <- structure(list(
      logical_path = paste0(lpath, "/", user, "/testthat/test"),
      metadata = list(structure(list(attribute = "foo",  value = "bar", units = "baz"), row.names = c(NA, -1L), class = "data.frame")),
      type = "data_object"
    ),
    row.names = c(NA, -1L),
    class = "data.frame"
    )

    expect_equal(ils(metadata = TRUE), ref)

  })
})

with_mock_dir("metadata-2", {
  test_that("metadata works 2" , {

    # double
    imeta(
      "test",
      "data_object",
      operations =
        list(
          list(operation = "add", attribute = "foo", value = "bar", units = "baz"),
          list(operation = "add", attribute = "foo2", value = "bar2", units = "baz2")
        )
    )

    # reference dataframe
    ref <- structure(list(
      logical_path = paste0(lpath, "/", user, "/testthat/test"),
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
    class = "data.frame"
    )

    expect_equal(ils(metadata = TRUE), ref)

  })
})

with_mock_dir("metadata-query", {
  test_that("metadata query works" , {

    # reference dataframe
    ref <- structure(list(
      collection = paste0(lpath, "/", user, "/testthat"),
      data_object = "test"
    ),
    row.names = c(1L),
    class = "data.frame"
    )

    # query
    expect_equal(
      iquery(
        paste0("SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '", lpath, "/%'")
      ),
      ref
    )

  })
})

with_mock_dir("metadata-remove", {
  test_that("metadata removing works" , {

    # remove metadata
    imeta(
      "test",
      "data_object",
      operations =
        list(
          list(operation = "remove", attribute = "foo", value = "bar", units = "baz"),
          list(operation = "remove", attribute = "foo2", value = "bar2", units = "baz2")
        )
    )

    # reference dataframe
    ref <- structure(list(
      logical_path = paste0(lpath, "/", user, "/testthat/test"),
      metadata = list(list()),
      type = "data_object"
    ),
    row.names = c(NA, -1L),
    class = "data.frame"
    )

    expect_equal(ils(metadata = TRUE), ref)

  })
})

test_that("list depth can be measured", {

  # several varying depth lists
  list1 <- list("x")
  list2 <- list(list("x"))
  list3 <- list(list(list("x")))

  expect_equal(list_depth(list1), 1L)
  expect_equal(list_depth(list2), 2L)
  expect_equal(list_depth(list3), 3L)
})
