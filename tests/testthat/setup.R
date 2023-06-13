library(httptest2)
library(httr2)

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

if (Sys.getenv("DEV_KEY_IRODS") != "") {
  user <- secret_decrypt(Sys.getenv("DEV_USER"), "DEV_KEY_IRODS")
  pass <- secret_decrypt(Sys.getenv("DEV_PASS"), "DEV_KEY_IRODS")
  lpath <- secret_decrypt(Sys.getenv("DEV_ZONE_PATH_IRODS"), "DEV_KEY_IRODS")
  host <- secret_decrypt(Sys.getenv("DEV_HOST_IRODS"), "DEV_KEY_IRODS")
} else {
  user <- "rods"
  pass <- "rods"
  lpath <- "/tempZone/home"
  host <- "http://localhost/irods-rest/0.9.3"
}

# try to run the server
tk <- try({

  # switch to new iRODS project
  create_irods(host, lpath, overwrite = TRUE)
  withr::defer(unlink("testthat.irods"), teardown_env())

  # creates a csv file of foo
  foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
  readr::write_csv(foo, "foo.csv")
  withr::defer(unlink("foo.csv"), teardown_env())

  # small file
  dfr <- data.frame(a = c("a", "b", "c"), b = 1:3, c = 6:8)
  readr::write_csv(dfr, "dfr.csv")
  withr::defer(unlink("dfr.csv"), teardown_env())

  # large file
  mt <- data.frame(x = 1:1000)
  readr::write_csv(mt, "mt.csv")
  withr::defer(unlink("mt.csv"), teardown_env())

  # authenticate
  iauth(user, pass, "rodsuser")

  # make tests collections (especially useful in case of remote server)
  def_path <- paste0(lpath, "/", user)
  if (!lpath_exists(paste0(def_path, "/testthat"))) imkdir("testthat")
  if (!lpath_exists(paste0(def_path, "/projectx"))) imkdir("projectx")

  # leave iRODS in clean state upon exit
  withr::defer(irm(
    paste0(def_path, "/testthat"),
    recursive = TRUE,
    force = TRUE
  ), teardown_env())
  withr::defer(irm(
    paste0(def_path, "/projectx"),
    recursive = TRUE,
    force = TRUE
  ), teardown_env())

  # move one level up
  icd("testthat")

  # token
  rirods:::get_token(paste(user, pass, sep = ":"), rirods:::find_irods_file("host"))
},
silent = TRUE
)

# fool the tests if no token is available (offline mode)
if (inherits(tk, "try-error")) {
  # set home dir
  # check path formatting, does it end with "/"? If not, then add it.
  if (!grepl("/$", rirods:::find_irods_file("zone_path")))
    zone_path <- paste0(rirods:::find_irods_file("zone_path"), "/")
  .rirods$current_dir <- paste0(zone_path, user, "/testthat")
  # store token
  assign("token", "secret", envir = .rirods)
} else {
  # if there is a real server then the mock files will be removed
  remove_mock_files()
}
