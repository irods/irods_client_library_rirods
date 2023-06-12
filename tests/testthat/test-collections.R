with_mock_dir("add-data-collections", {
  test_that("creating collections from iRODS works", {

    # simple collection
    expect_invisible(imkdir("a"))

    # collection within a collection
    expect_invisible(imkdir("x/a", create_parent_collections = TRUE))

    # reference dataframe
    ref <- structure(
      list(
        logical_path = paste0(lpath, "/", user, "/testthat", c("/a", "/x")),
        type = c("collection", "collection")
      ),
      row.names = c(1L, 2L),
      class = "irods_df"
    )

    # check if collections are added
    expect_equal(ils(), ref)

    # remove dirs
    irm("a", recursive = TRUE, force = TRUE)
    icd("./x")
    irm("a", recursive = TRUE, force = TRUE)
    icd("..")
    irm("x", recursive = TRUE, force = TRUE)

  })
})

with_mock_dir("remove-objects", {
  test_that("removing objects from iRODS works", {

    # currently mocking does not work
    skip_if(.rirods$token == "secret", "IRODS server unavailable")

    # store
    iput("foo.csv", "foo.csv", overwrite = TRUE)

    # delete object "foo.csv"
    expect_invisible(irm("foo.csv", force = TRUE))

    # check if file is delete
    expect_output(
      print(ils()),
      "This collection does not contain any objects or collections."
    )

    # r objects
    x <- 1
    isaveRDS(x, "x.rds", overwrite = TRUE)
    expect_invisible(irm("x.rds", force = TRUE))
  })
})
