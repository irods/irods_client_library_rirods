with_mock_dir("metadata", {
  test_that("metadata works", {

    # single
    imeta(
      "rods",
      "collection",
      operations =
        list(operation = "add", attribute = "foo", value = "bar", units = "baz")
    )

    expect_snapshot(ils(metadata = TRUE))

    # double
    imeta(
      "rods",
      "collection",
      operations =
        list(
          list(operation = "add", attribute = "foo", value = "bar", units = "baz"),
          list(operation = "add", attribute = "foo2", value = "bar2", units = "baz2")
        )
    )

    expect_snapshot(ils(metadata = TRUE))

    # query
    expect_snapshot(
      iquery(
        "SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '/tempZone/home/%'"
      )
    )

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
