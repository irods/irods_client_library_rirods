#' Launch iRODS from alternative directory
#'
#' This function is useful during development as it prevents cluttering of the
#' package source files.
#'
#' @param host Hostname of the iRODS server
#'  (default: "http://localhost/irods-rest/0.9.3").
#' @param zone_path Zone path of the iRODS server.
#' @param dir The directory to use (default is temporary directory).
#' @param env Attach exit handlers to this environment. Defaults to the
#'  parent frame (accessed through parent.frame()).
#'
#' @return Invisibly returns the original directory.
#'
#' @examples
#' if (interactive()) {
#'   # launch iRODS from temporary directory
#'   local_create_irods()
#' }
local_create_irods <- function(
    host = NULL,
    zone_path = NULL,
    dir = tempdir(),
    env = parent.frame()
  ) {

  # default host
  if (is.null(host)) {
    if (Sys.getenv("DEV_KEY_IROD") != "") {
      host <-
        httr2::secret_decrypt(Sys.getenv("DEV_HOST_IRODS"), "DEV_KEY_IRODS")
    } else {
      host <- "http://localhost/irods-rest/0.9.3"
    }
  }

  # defaults path
  if (is.null(zone_path)) {
    if (Sys.getenv("DEV_KEY_IROD") != "") {
      zone_path <-
        httr2::secret_decrypt(Sys.getenv("DEV_ZONE_PATH_IRODS"), "DEV_KEY_IRODS")
    } else {
      zone_path <- "/tempZone/home"
    }
  }

  # to return to
  old_dir <- getwd()

  # change working directory
  setwd(dir)
  withr::defer(setwd(old_dir), envir = env)

  # switch to new irods project
  create_irods(host, zone_path, overwrite = TRUE)

  invisible(dir)
}

#' Remove http snapshots or mockfiles
#'
#' @return Invisibly the mock file paths.
#'
remove_mock_files <- function() {
  # find the mock dirs
  pt <- file.path(getwd(), testthat::test_path())
  fls <- list.files(pt, include.dirs = TRUE)
  mockers <- fls[!grepl(pattern = "((.*)\\..*$)|(^_)",  x= fls)]
  # remove mock dirs
  unlink(file.path(pt, mockers), recursive = TRUE)
  invisible(file.path(pt, mockers))
}
