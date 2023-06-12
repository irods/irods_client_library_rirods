with_mock_dir("coerce-irods_df", {
  test_that("coerce irods_df to data.frame", {

    # some data
    foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
    isaveRDS(foo, "foo.rds", overwrite = TRUE)
    imeta(
      "foo.rds",
      "data_object",
      operations =
        data.frame(operation = "add", attribute = "foo", value = "bar",
          units = "baz")
     )

    # iRODS Zone with metadata
    irods_zone <- ils(metadata = TRUE)

    # check class
    expect_s3_class(irods_zone, "irods_df")

    # coerce into `data.frame` and extract metadata of "foo.rds"
    irods_zone <- as.data.frame(irods_zone)
    expect_snapshot(irods_zone)
    expect_snapshot(irods_zone[basename(irods_zone$logical_path) == "foo.rds", "metadata"])

    # remove objects
    irm("foo.rds")

  })
})

test_that("error on wrong structure", {
  # wrong input class
  expect_error(new_irods_df(matrix(1:10)))

  # wrong names of list
  expect_error(new_irods_df(list(wrong_name = 1:10)))

  # values of type wrong
  ref <- list(
    logical_path = paste0(lpath, "/", user, "/testthat/test.rds"),
    type = "wrong_value_type"
  )
  expect_error(new_irods_df(ref))
  ref$type <- "data_object"

  metadata <- list(structure(
    list(
      wrong = "foo",
      column = "bar",
      names = "baz"
    ),
    row.names = c(NA,-1L),
    class = "data.frame"
  ))

  # wrong column names of metadata frame
  ref$metadata <- metadata
  expect_error(new_irods_df(ref))
})
