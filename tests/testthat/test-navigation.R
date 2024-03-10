with_mock_dir("navigation", {
  test_that("navigation works", {

    # default dir
    expect_invisible(icd("."))
    expect_equal((icd(".")), ipwd()) # icd invisibly returns same as ipwd
    expect_equal(ipwd(), irods_test_path)

    # go back on level lower
    expect_invisible(icd(".."))
    expect_equal(ipwd(), def_path)

    # relative paths work as well
    expect_invisible(icd("testthat"))
    expect_equal(ipwd(), irods_test_path)

    icd("..") # move back to execute following test

    # relative paths work as well (in place dot)
    expect_invisible(icd("./testthat"))
    expect_equal(ipwd(), irods_test_path)

    # relative path in the same parent
    expect_invisible(icd("../projectx"))
    expect_equal(ipwd(), irods_test_path_x)

    test_iput(paste0(irods_test_path, "/dfr.csv"))

    # error when selecting file instead of collection
    expect_error(icd(paste0(irods_test_path, "/dfr.csv")))
    # or for typos and permissions errors
    expect_error(icd(paste0(def_path , "/projecty")))

    # whether trailing slash are removed
    expect_invisible(icd("../testthat"))
    expect_equal(ipwd(), irods_test_path)
    expect_gt(nrow(as.data.frame(ils())), 0L)
    expect_invisible(icd("./"))
    expect_equal(ipwd(), irods_test_path)
    expect_gt(nrow(as.data.frame(ils())), 0L)

    # clean-up
    test_irm(paste0(irods_test_path, "/dfr.csv"))

    # return to default path
    icd(irods_test_path)

  })
},
simplify = FALSE
)

with_mock_dir("list", {
  test_that("ils works", {
    # ils
    icd("..") # move back to execute following test
    expect_gt(nrow(as.data.frame(ils())), 0L)
    expect_equal(ncol(as.data.frame(ils())), 1L)
    expect_equal(ncol(as.data.frame(ils(stat = TRUE))), 10L)
    expect_message(print(ils("projectx")),
                  "This collection does not contain any objects or collections.")
    expect_message(print(ils("/tempZone/home/rods/projectx")),
                  "This collection does not contain any objects or collections.")
    expect_error(ils("tempZone/home/rods/projectx"))
    expect_error(ils("/projectx"))
    icd(irods_test_path) # move back up to testthat
  })
},
simplify = FALSE
)

with_mock_dir("list-limit-number-rows", {
  test_that("number of rows returned can be limited", {
    icd("..")
    out <- ils(limit = 1L)
    expect_equal(nrow(as.data.frame(out)), 1L)
    icd(irods_test_path) # move back up to testthat
  })
},
simplify = FALSE
)

with_mock_dir("list-stats", {
  test_that("stats of logical path can be extracted", {
    expect_s3_class(get_stat(irods_test_path), "data.frame")
    out <- make_ils_stat(irods_test_path)
    expect_equal(nrow(out), 1L)
    expect_equal(ncol(out), 9L)
  })
},
simplify = FALSE
)

with_mock_dir("list-metadata-0", {
  test_that("no metadata message is shown", {
    expect_message(make_ils_metadata(irods_test_path), "No metadata")
  })
},
simplify = FALSE
)

with_mock_dir("list-metadata-1", {
  test_that("metadata objects can be extracted", {
    test_imkdir(paste0(irods_test_path, "/new"))
    test_imkdir(paste0(irods_test_path, "/new2"))
    test_iput(paste0(irods_test_path, "/dfr.csv"))
    test_imeta(
      paste0(irods_test_path, "/dfr.csv"),
      operations =
        list(
          list(operation = "add", attribute = "foo", value = "bar", units = "baz"),
          list(operation = "add", attribute = "foo2", value = "bar2", units = "baz2")
        ),
      endpoint = "data-objects"
    )
    ref <- structure(
      list(
        logical_path = rep(paste0(irods_test_path, "/dfr.csv"), 2),
        attribute = c("foo", "foo2"),
        value = c("bar", "bar2"),
        units = c("baz", "baz2")
      ),
      row.names = 1:2,
      class = "data.frame"
    )
    ils_meta <- make_ils_metadata(irods_test_path)
    expect_equal(ils_meta, ref)
  })
},
simplify = FALSE
)

with_mock_dir("list-metadata-2", {
  test_that("metadata collections can be extracted", {
    test_imeta(
      paste0(irods_test_path, "/new"),
      operations =
        list(
          list(operation = "add", attribute = "foo", value = "bar", units = "baz"),
          list(operation = "add", attribute = "foo2", value = "bar2", units = "baz2")
        ),
      endpoint = "collections"
    )
    ref <- structure(
      list(
        logical_path = paste0(irods_test_path, "/", c("new", "new", "dfr.csv", "dfr.csv")),
        attribute = c("foo", "foo2", "foo", "foo2"),
        value = c("bar", "bar2", "bar", "bar2"),
        units = c("baz", "baz2", "baz", "baz2")
      ),
      row.names = 1:4,
      class = "data.frame"
    )
    ils_meta <- make_ils_metadata(irods_test_path)
    expect_equal(ils_meta, ref)
  })
},
simplify = FALSE
)

with_mock_dir("list-metadata-3", {
  test_that("metadata collections and objects can be extracted", {
    ref <- structure(
      list(
        logical_path = paste0(irods_test_path, "/", c("dfr.csv", "dfr.csv", "new", "new", "new2")),
        attribute = c( "foo", "foo2", "foo", "foo2", NA_character_),
        value = c("bar", "bar2", "bar", "bar2", NA_character_),
        units = c("baz", "baz2", "baz", "baz2", NA_character_)
      ),
      row.names = 1:5,
      class = "irods_df"
    )
    out <- ils(metadata = TRUE)
    expect_equal(out, ref)
    test_irm(paste0(irods_test_path, "/new"), "collections")
    test_irm(paste0(irods_test_path, "/new2"), "collections")
    test_irm(paste0(irods_test_path, "/dfr.csv"))
  })
},
simplify = FALSE
)
