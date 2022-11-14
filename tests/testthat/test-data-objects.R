with_mock_dir("data-objects", {
  test_that("external data-objects management works", {

    # a bunch of datasets
    rng <- c(1:5)
    ls_data <- ls("package:datasets")
    get_data <- mget(ls_data[rng], as.environment("package:datasets"))
    ls_data <- gsub("\\.", "_", ls_data)
    for(i in seq_along(rng)) {
      # assign to environment
      assign(ls_data[i], get_data[[i]])
      # upload to irods
      expect_invisible(
        eval(
          substitute(
            iput(x, y, overwrite = TRUE),
            list(
              x = str2lang(ls_data[i]),
              y = paste0(ls_data[i], ".rds")
            )
          )
        )
      )
      # retrieve object
      X <- iget(paste0(ls_data[i], ".rds"))
      expect_equal(X, eval(str2lang(ls_data[i])))
      # remove object
      expect_invisible(irm(paste0(ls_data[i], ".rds")))
    }

    # store file
    expect_invisible(iput("foo.csv", "foo.csv", overwrite = TRUE))

    # retrieve object
    iget("foo.csv", overwrite = TRUE)
    expect_equal(read.csv("foo.csv"), foo)

    # remove object
    expect_invisible(irm("foo.csv"))
  })
},
simplify = FALSE
)

test_that("overwrite error works", {

  # overwrite error on irods
  test <- "test"
  expect_error(
    iput(
      test,
      path = paste0(lpath, "/", user, "/testthat")
    )
  )

  # overwrite error locally
  test_file <- tempfile(fileext = ".csv")
  expect_error(iget(basename(test_file), path = dirname(test_file)))

})

# test_that("shell equals R solution", {
#
#   # this can not be accommodated by httptest2
#   skip_if_offline()
#   skip_if(inherits(tk, "try-error"))
#
#   # curl in shell
#   system2(
#     system.file(package = "rirods", "bash", "iput.sh"),
#     c(user, pass, host, paste0(def_path, "/testthat") , 0, 8192L),
#     stdout = NULL,
#     stderr = NULL
#   )
#
#   # get back from shell
#   system2(
#     system.file(package = "rirods", "bash", "iget.sh"),
#     c(user, pass, host, paste0(def_path, "/testthat/foo.rds") , 0, 8192L),
#     stdout = NULL,
#     stderr = NULL
#   )
#
#   # get shell put object
#   shell <- readRDS("foo.rds")
#   expect_equal(shell, foo)
#
#   # remove file
#   unlink("foo.rds")
#
#   # remove object
#   expect_invisible(irm(paste0(def_path, "/testthat/foo.rds")))
# })
