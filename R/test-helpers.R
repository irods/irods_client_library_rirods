# remove httptest2 mock files
remove_mock_files <- function() {
  # find the mock dirs
  pt <- file.path(usethis::proj_get(), testthat::test_path())
  fls <- list.files(pt, include.dirs = TRUE)
  mockers <- fls[!grepl(pattern = "((.*)\\..*$)|(^_)",  x= fls)]
  # remove mock dirs
  unlink(file.path(pt, mockers), recursive = TRUE)
  # remove .gitignore
  unlink(file.path(pt, ".gitignore"))
}

# create local irods instance in temp dir
local_create_irods <- function(
    host = Sys.getenv("DEV_HOST_IRODS"),
    zone_path = Sys.getenv("DEV_ZONE_PATH_IRODS"),
    dir = tempdir(),
    env = parent.frame()
  ) {

  # to return to
  old_dir <- getwd()

  # change working directory
  setwd(dir)
  withr::defer(setwd(old_dir), envir = env)

  # switch to new irods project
  create_irods(host, zone_path, overwrite = TRUE)

  invisible(dir)
}
