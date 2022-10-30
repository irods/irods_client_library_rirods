library(httptest2)

try({

  # write an gitignore file
  cat(
    "**/*.R",
    file = ".gitignore",
    sep = "\n"
  )

  # switch to new irods project
  create_irods(Sys.getenv("DEV_HOST_IRODS"), overwrite = TRUE)
  withr::defer(unlink("testthat.irods"), teardown_env())

  # some data
  foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

  # creates a csv file of foo
  readr::write_csv(foo, "foo.csv")
  withr::defer(unlink("foo.csv"), teardown_env())

  # authenticate
  iauth("rods", "rods")

  # add user bobby
  rirods:::iadmin(
    action = "add",
    target = "user",
    arg2 = "bobby",
    arg3 = "rodsuser"
  )

  # modify pass word bobby
  rirods:::iadmin(
    action = "modify",
    target = "user",
    arg2 = "bobby",
    arg3 = "password",
    arg4  = "passWORD"
  )

  # test object
  iauth("bobby", "passWORD")
  test <- 1
  iput(test, path = "/tempZone/home/bobby", overwrite = TRUE)

  # authenticate
  iauth("rods", "rods")

},
silent = TRUE
)

# fool the tests if no token is available (offline mode)
tk <- try(
  get_token(paste("rods", "rods", sep = ":"), find_host()),
  silent = TRUE
)
if (inherits(tk, "try-error")) {
  # set home dir
  .rirods$current_dir <- "/tempZone/home"
  # store token
  assign("token", "secret", envir = .rirods)
}

