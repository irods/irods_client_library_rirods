with_mock_dir("add-data-collections", {
  test_that("creating collections from iRODS works", {

    # simple collection
    expect_invisible(imkdir("a"))

    # collection within a collection
    expect_invisible(imkdir("x/a", create_parent_collections = TRUE))

    # reference dataframe
    ref <- data.frame(
      logical_path = paste0(lpath, "/", user, "/testthat", c("/a", "/x", "/test.rds")),
      type = c("collection", "collection", "data_object")
    )

    # check if collections are added
    expect_equal(ils(), ref)

    # remove dirs
    irm("a", recursive = TRUE, force = FALSE)
    icd("./x")
    irm("a", recursive = TRUE, force = FALSE)
    icd("..")
    irm("x", recursive = TRUE, force = FALSE)

  })
})

with_mock_dir("remove-objects", {
  test_that("removing objects from iRODS works", {

    # currently mocking does not work
    skip_if(.rirods$token == "secret", "IRODS server unavailable")

    # store
    iput("foo.csv", "foo.csv", overwrite = TRUE)

    # delete object "foo.csv"
    expect_invisible(irm("foo.csv", force = FALSE))

    # reference dataframe
    ref <- data.frame(
      logical_path = paste0(lpath, "/", user, "/testthat/test.rds"),
      type = "data_object"
    )

    # check if file is delete
    expect_equal(ils(), ref)

    # r objects
    x <- 1
    isaveRDS(x, "x.rds", overwrite = TRUE)
    expect_invisible(irm("x.rds", trash = FALSE))
  })
})
