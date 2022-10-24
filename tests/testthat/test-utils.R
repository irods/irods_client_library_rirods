with_mock_dir("helpers", {
  test_that("irods object helpers work", {

    # path exists
    expect_true(path_exists("/tempZone/home/bobby"))
    expect_false(path_exists("/tempZone/home/frank"))

    # collection exists
    expect_true(is_collection("/tempZone/home/bobby")) # is a collection
    expect_false(is_collection("/tempZone/home/bobby/test")) # is a data object
    expect_error(is_collection("/tempZone/home/frank")) # does not exist at all

    # object exists
    expect_true(is_object("/tempZone/home/bobby/test")) # is a data object
    expect_false(is_object("/tempZone/home/bobby")) # is a collection
    expect_error(is_object("/tempZone/home/frank/test")) # does not exist at all
  })
})
