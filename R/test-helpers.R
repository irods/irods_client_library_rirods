use_irods_demo <- function(action = "up") {

  # does it exist
  pt <- system("find ~ -path ~/.local  -prune -o -type d -name 'irods_demo' -print", intern = TRUE)
  if (length(pt) == 0)
    warning("The iRODS demo is not installed on this system. Using http mock files instead.", call. = FALSE)

  if (action == "up") {
    system(paste0("cd ",pt ," ; docker-compose up -d nginx-reverse-proxy"))
  } else if (action == "down") {
    system(paste0("cd ",pt ," ; docker-compose down"))
  } else {
    stop("Action unkown.", call. = FALSE)
  }
}

# remove httptest2 mock files
remove_mock_files <- function() {
  # find the mock dirs
  pt <- file.path(getwd(), testthat::test_path())
  fls <- list.files(pt, include.dirs = TRUE)
  mockers <- fls[!grepl(pattern = "((.*)\\..*$)|(^_)",  x= fls)]
  # remove mock dirs
  unlink(file.path(pt, mockers), recursive = TRUE)
  # remove .gitignore
  unlink(file.path(pt, ".gitignore"))
}

# create local irods instance in temp dir
local_create_irods <- function(
    host = NULL,
    zone_path = NULL,
    dir = tempdir(),
    env = parent.frame()
  ) {

  # default host
  if (is.null(host)) {
    if (Sys.getenv("DEV_KEY_IROD") != "") {
      host <- httr2::secret_decrypt(Sys.getenv("DEV_HOST_IRODS"), "DEV_KEY_IRODS")
    } else {
      host <- "http://localhost/irods-rest/0.9.3"
    }
  }

  # defaults path
  if (is.null(zone_path)) {
    if (Sys.getenv("DEV_KEY_IROD") != "") {
      zone_path <- httr2::secret_decrypt(Sys.getenv("DEV_ZONE_PATH_IRODS"), "DEV_KEY_IRODS")
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

