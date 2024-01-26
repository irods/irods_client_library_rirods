with_mock_dir("expand-path", {
  test_that("expand path works", {

    expect_equal(make_irods_base_path(),
                 paste0("/", find_irods_file("irods_zone"), "/home/", .rirods$user))

    # move up
    icd("..")
    icd("..")

    # relative
    expect_equal(get_absolute_lpath(user), def_path)
    # relative
    expect_equal(
      get_absolute_lpath(paste0(user, "/testthat")),
      irods_test_path
    )
    # absolute
    expect_equal(
      get_absolute_lpath(def_path),
      def_path
    )
    # error
    expect_error(get_absolute_lpath(paste0(lpath, "/frank")))
    expect_error(get_absolute_lpath("frank"))

    # checks paths for writing
    icd(irods_test_path)

    expect_equal(
      get_absolute_lpath("x/y", write = TRUE),
      paste0(irods_test_path, "/x/y")
    )
    expect_equal(
      get_absolute_lpath(paste0(irods_test_path, "/x"), write = TRUE),
      paste0(irods_test_path, "/x")
    )
  })
})

with_mock_dir("object-helpers", {
  test_that("irods object helpers work", {

    test_iput(paste0(irods_test_path, "/dfr.csv"))

    # path exists
    expect_true(lpath_exists(def_path))
    expect_false(lpath_exists(paste0(dirname(def_path), "/frank")))
    # collection exists
    expect_true(is_collection(def_path)) # is a collection
    expect_false(is_collection(paste0(irods_test_path, "/dfr.csv"))) # is a data object
    expect_error(is_collection(paste0(dirname(def_path), "/frank"))) # does not exist at all
    # object exists
    expect_true(is_object(paste0(irods_test_path, "/dfr.csv"))) # is a data object
    expect_false(is_object(def_path)) # is a collection
    expect_error(is_object(paste0(irods_test_path_x, "test.rds"))) # does not exist at all

    # clean-up
    test_irm(paste0(irods_test_path, "/dfr.csv"))
  })
},
simplify = FALSE
)
