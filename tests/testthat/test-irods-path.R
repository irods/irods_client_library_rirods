with_mock_dir("expand-path", {
  test_that("expand path works", {

    # reference
    ref <- paste0(lpath, "/", user)

    # move up
    icd("..")
    icd("..")
    # relative
    expect_equal(get_absolute_lpath(user), ref)
    # relative
    expect_equal(
      get_absolute_lpath(paste0(user, "/testthat")),
      paste0(ref, "/testthat")
    )
    # absolute
    expect_equal(
      get_absolute_lpath(paste0(lpath, "/", user)),
      ref
    )
    # error
    expect_error(get_absolute_lpath(paste0(lpath, "/frank"), open = "read"))
    expect_error(get_absolute_lpath("frank", open = "read"))
    # return to test level dir
    icd(paste0(user, "/testthat"))
  })
})

with_mock_dir("object-helpers", {
  test_that("irods object helpers work", {

    # path exists
    expect_true(lpath_exists(paste0(lpath, "/", user)))
    expect_false(lpath_exists(paste0(lpath, "/frank")))

    # collection exists
    expect_true(is_collection(paste0(lpath, "/", user))) # is a collection
    expect_false(is_collection(paste0(lpath, "/", user, "/testthat/test.rds"))) # is a data object
    expect_error(is_collection(paste0(lpath, "/frank"))) # does not exist at all

    # object exists
    expect_true(is_object(paste0(lpath, "/", user, "/testthat/test.rds"))) # is a data object
    expect_false(is_object(paste0(lpath, "/", user))) # is a collection
    expect_error(is_object(paste0(lpath, "/projectx/test.rds"))) # does not exist at all
  })
},
simplify = FALSE
)
