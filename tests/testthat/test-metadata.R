with_mock_dir("metadata-1", {
  test_that("metadata works for collections" , {

    expect_invisible(
      imeta(
        irods_test_path,
        operations =
          list(list(operation = "add", attribute = "foo", value = "bar", units = "baz"))
      )
    )

    expect_invisible(q1 <- iquery(collection_metadata(def_path, recurse = TRUE)))
    expect_invisible(q2 <- iquery(collection_metadata(irods_test_path)))

    # # reference `dataframe`
    ref <- structure(
      list(
        COLL_NAME = irods_test_path,
        META_COLL_ATTR_NAME = "foo",
        META_COLL_ATTR_VALUE = "bar",
        META_COLL_ATTR_UNITS = "baz"
      ),
      row.names = c(NA,-1L),
      class = "data.frame"
    )

    expect_s3_class(q2, "data.frame")
    expect_equal(q1, ref)
  })
},
simplify = FALSE
)

with_mock_dir("metadata-2", {
  test_that("metadata works for data objects" , {

    # test object
    test_iput(paste0(irods_test_path, "/dfr.csv"))

    # single
    expect_invisible(
      imeta(
        "dfr.csv",
        operations =
          list(list(operation = "add", attribute = "foo", value = "bar", units = "baz"))
      )
    )

    # double
    expect_invisible(
      imeta(
        "dfr.csv",
        operations =
          list(
            list(operation = "add", attribute = "foo", value = "bar", units = "baz"),
            list(operation = "add", attribute = "foo2", value = "bar2", units = "baz2")
          )
      )
    )

    # # reference `dataframe`
    ref <- structure(
      list(
        META_DATA_ATTR_NAME = c("foo", "foo2"),
        META_DATA_ATTR_VALUE = c("bar", "bar2"),
        META_DATA_ATTR_UNITS = c("baz", "baz2")
      ),
      row.names = c(1L, 2L),
      class = "data.frame"
    )

   expect_invisible(q <- iquery(data_object_metadata(irods_test_path, "dfr.csv")))

    expect_s3_class(q, "data.frame")
    expect_equal(q, ref)
  })
},
simplify = FALSE
)

with_mock_dir("metadata-3", {
  test_that("metadata works 3" , {
    # In this check we address Issue #23:
    # "Metadata columns in wrong order when some item has no metadata"

    # For this we need a second `data_object`, but for the rest the test is the
    # same as above "metadata works 2".
    some_object <- 1:10
    isaveRDS(some_object, "some_object.rds")

    # reference `data.frame`
    ref <- structure(
      list(
        COLL_NAME = c(irods_test_path, irods_test_path),
        DATA_NAME = c("dfr.csv", "dfr.csv"),
        META_DATA_ATTR_NAME = c("foo", "foo2"),
        META_DATA_ATTR_VALUE = c("bar", "bar2"),
        META_DATA_ATTR_UNITS = c("baz", "baz2")
      ),
      row.names = c(1L, 2L),
      class = "data.frame"
    )

    expect_equal(iquery(data_object_metadata(irods_test_path)), ref)

    test_irm(paste0(irods_test_path, "/some_object.rds"))
  })
},
simplify = FALSE
)

with_mock_dir("metadata-errors", {
  test_that("metadata errors" , {
    # In this check we address Issue #23:
    # "The code would check and force that operations is a list of lists"

    error_type1  <- c("x") # type error
    error_msg1 <- "The supplied `operations` should be of type `list` or `data.frame`."

    expect_error(imeta("dfr.csv", operation =  error_type1), error_msg1)

    error_type2  <- list("x") # type error
    error_msg2 <- "The supplied list of `operations` should contain a named `list`."

    expect_error(imeta("dfr.csv", operation =  error_type2), error_msg2)

    error_names1 <- list(list(x=1)) # naming error
    error_names2 <- data.frame(x=1) # naming error
    error_msg3 <- "The supplied `operations` should have names that can include \"operation\", \"attribute\", \"value\", \"units\"."

    expect_error(imeta("dfr.csv", operation =  error_names1), error_msg3)
    expect_error(imeta("dfr.csv", operation =  error_names2), error_msg3)

    error_content <- list(list(operation = "modify"))
    error_msg4 <- "The element \"operation\" of `operations` can contain \"add\" or \"remove\"."
    expect_error(imeta("dfr.csv", operation =  error_content), error_msg4)
  })
},
simplify = FALSE
)

# with_mock_dir("metadata-query", {
  test_that("metadata query columns are ok" , {

    skip_on_cran()
    skip_on_covr()
    skip_on_ci()

    # snapshot keeps changing (time search)
    skip_if(!is_irods_demo_running(), "Only for interactive testing.")

    # query
    iq <- iquery(
      paste0("SELECT COLL_NAME, DATA_NAME, DATA_SIZE, COLL_CREATE_TIME WHERE COLL_NAME LIKE '", def_path, "/%'")
    )

    expect_equal(
      colnames(iq),
      c("COLL_NAME", "DATA_NAME", "DATA_SIZE", "COLL_CREATE_TIME")
      )
    expect_type(iq$COLL_NAME, "character")
    expect_type(iq$DATA_NAME, "character")
    expect_type(iq$DATA_SIZE, "double")
    expect_s3_class(iq$COLL_CREATE_TIME, "POSIXct")

    # limit number of returned rows
    iquery(data_object_metadata(irods_test_path), limit = 1)

  })
# },
# simplify = FALSE
# )

with_mock_dir("metadata-remove", {
  test_that("metadata removing works" , {

    # remove metadata
    imeta(
      "dfr.csv",
      operations =
        list(
          list(operation = "remove", attribute = "foo", value = "bar", units = "baz"),
          list(operation = "remove", attribute = "foo2", value = "bar2", units = "baz2")
        )
    )

    expect_equal(iquery(data_object_metadata(irods_test_path)), list())

    # clean-up
    test_irm(paste0(irods_test_path, "/dfr.csv"))
  })
},
simplify = FALSE
)
