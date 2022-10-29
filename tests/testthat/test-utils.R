with_mock_dir("irods-rest-call", {
  test_that("irods rest call works", {

    # flags to curl call
    args <- list(
      `logical-path` = "/tempZone/home/bobby",
      stat = 1,
      permissions = 1,
      metadata = 1,
      offset = 0,
      limit = 100
    )

    # with a httr response
    expect_s3_class(
      irods_rest_call("list", "GET", args, FALSE),
      "httr2_response"
    )

  })
})

with_mock_dir("object-helpers", {
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
},
simplify = FALSE
)
