with_mock_dir("add-data-collections-1", {
  test_that("creating collections from iRODS works", {
    # simple collection
    expect_invisible(imkdir("a"))

    # reference dataframe
    ref <- structure(
      list(
        logical_path = paste0(irods_test_path, "/a")
      ),
      row.names = 1L,
      class = "irods_df"
    )

    # check if collections are added
    expect_equal(ils(), ref)
  })
},
simplify = FALSE
)

with_mock_dir("add-data-collections-2", {
  test_that("creating collections recursively from iRODS works", {

    # collection within a collection
    expect_invisible(imkdir("x/a", create_parent_collections = TRUE))

    # reference dataframe
    ref <- structure(
      list(
        logical_path = paste0(irods_test_path, c("/a", "/x"))
      ),
      row.names = c(1L, 2L),
      class = "irods_df"
    )

    # check if collections are added
    expect_equal(ils(), ref)
  })
},
simplify = FALSE
)

with_mock_dir("remove-data-collections-1", {
  test_that("removing collections from iRODS works", {
    expect_invisible(irm("a", force = TRUE))
  })
},
simplify = FALSE
)

with_mock_dir("remove-data-collections-2", {
  test_that("removing collections recursive from iRODS works", {
    expect_invisible(irm("x", recursive = TRUE, force = TRUE))
  })
},
simplify = FALSE
)

with_mock_dir("remove-objects", {
  test_that("removing objects from iRODS works", {

    test_iput(paste0(irods_test_path, "/dfr.csv"))

    # delete object "dfr.csv"
    expect_invisible(irm("dfr.csv", force = TRUE))

    # check if file is delete
    expect_message(
      print(ils()),
      "This collection does not contain any objects or collections."
    )
  })
},
simplify = FALSE
)
