test_that("multiplication works", {

  # cerate local
  local_create_irods()

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


})
