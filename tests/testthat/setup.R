library(httptest2)
library(httr2)

#-------------------------------------------------------------------------------
# Snapshots are created with github actions using the latest irods_demo
# configuration. Hence we set these environmental variables as default when
# loading the package and no environmental variables are set. This ensures
# that CRAN checks won't fail. In case of testing on your own sever, you have
# to create a package development key with the httr2 package and place it
# in your environmental variables. To use the scrambled server information in
# the tests place them in your project level environmental variable
# (possibly place those in your .Rprofile for convenience)
#-------------------------------------------------------------------------------

if (Sys.getenv("DEV_KEY_IRODS") != "") {
  user <- secret_decrypt(Sys.getenv("DEV_USER"), "DEV_KEY_IRODS")
  pass <- secret_decrypt(Sys.getenv("DEV_PASS"), "DEV_KEY_IRODS")
  host <- secret_decrypt(Sys.getenv("DEV_HOST_IRODS"), "DEV_KEY_IRODS")
} else {
  user <- "rods"
  pass <- "rods"
  host <- rirods:::.irods_host
}

# set user config directory to temporary location
withr::local_envvar(
  R_USER_CONFIG_DIR = tempdir(),
  .local_envir = teardown_env()
)

# small file (serialized size 400 bytes)
dfr <- data.frame(a = c("a", "b", "c"), b = 1:3, c = 6:8)
readr::write_csv(dfr, "dfr.csv")
withr::defer(unlink("dfr.csv"), teardown_env())

# try to run the server
tk <- try({

  # switch to new iRODS project
  create_irods(host, overwrite = TRUE)
  withr::defer(unlink(path_to_irods_conf()), teardown_env())

  # authenticate
  iauth(user, pass, "rodsuser")

  def_path <- rirods:::make_irods_base_path()
  irods_test_path <- paste0(def_path, "/testthat")
  irods_test_path_x <- paste0(def_path, "/projectx")
  # make tests collections (especially useful in case of remote server)
  if (!lpath_exists(irods_test_path)) test_imkdir(irods_test_path)
  if (!lpath_exists(irods_test_path_x)) test_imkdir(irods_test_path_x)

  # leave iRODS in clean state upon exit
  withr::defer(test_irm(irods_test_path, "collections"), teardown_env())
  withr::defer(test_irm(irods_test_path_x, "collections"), teardown_env())

  # move one level up
  icd("testthat")

  # token
  rirods:::get_token(user, pass, rirods:::find_irods_file("host"))
},
silent = TRUE
)

# fool the tests if no token is available (offline mode)
if (inherits(tk, "try-error")) {
  # mock configuration
  file.create(path_to_irods_conf())
  write(
    jsonlite::toJSON(list(
      host = host,
      irods_zone = "tempZone",
      max_number_of_parallel_write_streams = 3L,
      max_number_of_rows_per_catalog_query = 15L,
      max_size_of_request_body_in_bytes = 8388608L
    ), auto_unbox = TRUE, pretty = TRUE),
    file = path_to_irods_conf()
  )
  # mock user information
  .rirods$user_role <- "rodsuser"
  def_path <- make_irods_base_path()
  irods_test_path <- paste0(def_path, "/testthat")
  irods_test_path_x <- paste0(def_path, "/projectx")
  # set home dir
  .rirods$current_dir <- irods_test_path
  # store token
  assign("token", "secret", envir = .rirods)
} else {
  # if there is a real server then the mock files will be removed
  remove_mock_files()
}
