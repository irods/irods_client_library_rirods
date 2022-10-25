with_mock_dir("data-collections", {
  test_that("removing objects from iRODS works", {

    # data
    foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

    # creates a csv file of foo
    readr::write_csv(foo, "foo.csv")

    # store
    iput("foo.csv", overwrite = TRUE)

    # delete object "test"
    expect_invisible(irm("foo.csv", trash = FALSE))

    # check if file is delete
    expect_snapshot(ils())

    # garbage collect
    unlink("foo.csv")
  })
})
