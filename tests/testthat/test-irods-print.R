with_mock_dir("print-1", {
  test_that("output is printed 1", {
    # no content
    expect_output(print(ils()), "This collection does not contain any objects or collections.")
  })
})

with_mock_dir("print-2", {
  test_that("output is printed 2", {
    # object 1
    fred <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
    isaveRDS(fred, "fred.rds", overwrite = TRUE)

    # object 2
    qux <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
    isaveRDS(qux, "qux.rds")

    # metadata for object 1
    imeta(
      "fred.rds",
      "data_object",
      operations =
        list(list(operation = "add", attribute = "foo", value = "bar", units = "baz"))
    )

    expect_snapshot(print(ils()))
    expect_snapshot(print(ils(metadata = TRUE)))
  })
})

with_mock_dir("print-3", {
  test_that("output is printed 3", {
    # multiple metadata for object 1
    imeta(
      "fred.rds",
      "data_object",
      operations =
        list(list(operation = "add", attribute = "foo1", value = "bar1", units = "baz1"))
    )

    expect_snapshot(print(ils(metadata = TRUE)))
  })
})

with_mock_dir("print-4", {
  test_that("output is printed 4", {
    # metadata for object 2
    imeta(
      "qux.rds",
      "data_object",
      operations =
        list(list(operation = "add", attribute = "foo", value = "bar"))
    )

    expect_snapshot(print(ils(metadata = TRUE)))

    # permissions
    expect_snapshot(print(ils(metadata = TRUE, permissions = TRUE)))

    # remove objects
    irm("fred.rds", force = TRUE)
    irm("qux.rds", force = TRUE)

  })
})
