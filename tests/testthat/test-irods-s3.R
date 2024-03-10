test_that("data structure input", {

  # wrong input class
  expect_error(new_irods_df(matrix(1:10)))

  # wrong names of list
  expect_error(new_irods_df(list(wrong_name = 1:10)))

  # empty iRODS collection
  expect_message(print(new_irods_df(data.frame())))

})

with_mock_dir("coerce-irods_df", {
  test_that("coerce irods_df to data.frame", {

    # some data
    test_iput(paste0(irods_test_path, "/dfr.csv"))
    test_imeta(
      paste0(irods_test_path, "/dfr.csv"),
      operations =
        list(
          list(operation = "add", attribute = "foo", value = "bar", units = "baz")
        ),
      endpoint = "data-objects"
    )

    # iRODS Zone with metadata
    irods_zone <- ils(metadata = TRUE)

    # check class
    expect_s3_class(irods_zone, "irods_df")

    # coerce into `data.frame` and extract metadata of "dfr.csv"
    ref <- structure(
      list(
        logical_path = paste0(irods_test_path, "/dfr.csv"),
        attribute = "foo",
        value = "bar",
        units = "baz"
      ),
      row.names = 1L,
      class = "data.frame"
    )
    irods_zone <- as.data.frame(irods_zone)
    expect_equal(irods_zone, ref)

    # delete object "dfr.csv"
    expect_invisible(irm("dfr.csv", force = TRUE))

  })
},
simplify = FALSE
)
