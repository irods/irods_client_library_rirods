test_that("irods demo works on linux", {

  skip_on_cran()
  skip_on_covr()
  skip_on_ci()
  skip("Only for interactive testing.")

  # only tested on linux
  skip_on_os(c("windows", "mac", "solaris"))

  # only works on demo server
  skip_if(Sys.getenv("DEV_KEY_IRODS") != "", "Only for demo server.")
  previous_state_irods_demo <- is_irods_demo_running()

  expect_invisible(suppressMessages(use_irods_demo()))
  expect_true(is_irods_demo_running())

  # if iRODS was not running at first then shut it down again
  if (isFALSE(previous_state_irods_demo)) {
    stop_irods_demo()
    # set token
    .rirods$token <- "secret"
  }
   # set iRODS logical path back to testthat
  def_path <- paste0(lpath, "/", user)
  dev_path <- paste0(def_path, "/testthat")
  .rirods$current_dir <- dev_path
})
