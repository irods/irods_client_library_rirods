with_mock_dir("add-data-collections", {
  test_that("creating collections from iRODS works", {

    # simple collection
    expect_invisible(imkdir("a"))

    # collection within a collection
    expect_invisible(imkdir("x/a", create_parent_collections = TRUE))

    # check if collections are added
    expect_snapshot(ils())

    # remove dirs
    irm("a", recursive = TRUE)
    icd("../x")
    irm("a", recursive = TRUE)
    icd("..")
    irm("x", recursive = TRUE)
  })
})

with_mock_dir("remove-objects", {
  test_that("removing objects from iRODS works", {

    # store
    iput("foo.csv", overwrite = TRUE)

    # delete object "foo.csv"
    expect_invisible(irm("foo.csv", trash = FALSE))

    # check if file is delete
    expect_snapshot(ils())

  })
})
