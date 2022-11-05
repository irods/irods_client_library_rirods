library(httptest2)

#-----------------------------------------------------------------------------
# Snapshots are created with github actions and use the latest irods_demo
# configuration. Hence we set these environmental variables as default when
# loading the package and no environmental variables are set. This ensures
# that CRAN checks won't fail. In case of testing on your own sever, you have
# to create a package development key with the httr2 package and place it
# in your environmental variables. To use the scrambled server information in
# the tests place them in your project level environmental variable
# (possibly place those in your .Rprofile for convenience)
#-----------------------------------------------------------------------------

if (Sys.getenv("DEV_KEY_IROD") != "") {
  user <- httr2::secret_decrypt(Sys.getenv("DEV_USER"), "DEV_KEY_IRODS")
  pass <- httr2::secret_decrypt(Sys.getenv("DEV_PASS"), "DEV_KEY_IRODS")
  lpath <- httr2::secret_decrypt(Sys.getenv("DEV_ZONE_PATH_IRODS"), "DEV_KEY_IRODS")
  host <- httr2::secret_decrypt(Sys.getenv("DEV_HOST_IRODS"), "DEV_KEY_IRODS")
} else {
  user <- "rods"
  pass <- "rods"
  lpath <- "/tempZone/home"
  host <- "http://localhost/irods-rest/0.9.3"
}

# try to run the server
tk <- try({

  # write an gitignore file
  if (!file.exists(".gitignore")) {
    cat(
      "**/*.R",
      file = ".gitignore",
      sep = "\n"
    )
  }

  # switch to new irods project
  create_irods(host, lpath, overwrite = TRUE)
  withr::defer(unlink("testthat.irods"), teardown_env())

  # some data
  foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

  # creates a csv file of foo
  readr::write_csv(foo, "foo.csv")
  withr::defer(unlink("foo.csv"), teardown_env())

  # authenticate
  iauth(user, pass, "rodsuser")

  # make tests collections
  def_path <- paste0(lpath, "/", user)
  if (!path_exists(paste0(def_path, "/testthat"))) imkdir("testthat")
  if (!path_exists(paste0(def_path, "/projectx"))) imkdir("projectx")

  # move one level up
  icd("./testthat")

  # test object
  test <- 1
  iput(test, overwrite = TRUE)

  # token
  get_token(paste(user, pass, sep = ":"), find_irods_file("host"))
},
silent = TRUE
)

# fool the tests if no token is available (offline mode)
if (inherits(tk, "try-error")) {
  # set home dir
  # check path formatting, does it end with "/"? If not, then add it.
  if (!grepl("/$", find_irods_file("zone_path")))
    zone_path <- paste0(find_irods_file("zone_path"), "/")
  .rirods$current_dir <- paste0(zone_path, user, "/testthat")
  # store token
  assign("token", "secret", envir = .rirods)
}
