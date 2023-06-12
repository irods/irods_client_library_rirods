#' Generate IRODS Project File
#'
#' This will create an iRODS project file containing information about the
#' iRODS server. Once the file has been created, future sessions
#' connect again with the same iRODS server without further intervention.
#'
#' @param host URL of host.
#' @param zone_path Path to the zone of the iRODS server (e.g., "/tempZone/home").
#' @param path Path of project. Defaults to the top directory of the zone.
#' @param overwrite Overwrite existing iRODS project file. Defaults to `FALSE`.
#'
#' @return Invisibly, the path to the iRODS project file.
#' @export
#'
create_irods <- function(
    host,
    zone_path,
    path = ".",
    overwrite = FALSE
  ) {

  # project name
  name <- basename(getwd())
  path <- file.path(path, paste0(name, ".irods"))

  # check for existence of irods project file
  if (file.exists(path) && isFALSE(overwrite))
    stop(
      "Irods file already exists. If you want to overwrite this file then",
      " set `overwrite` to TRUE.",
      call. = FALSE
    )

  # create file
  file.create(path)
  cat(
    paste0("host: ", host),
    paste0("zone_path: ", zone_path),
    sep = "\n",
    file = path
  )

  # path
  invisible(path)
}

#' Launch iRODS from Alternative Directory
#'
#' This function is useful during development as it prevents cluttering of the
#' package source files.
#'
#' @param host Hostname of the iRODS server. Defaults to
#'  "http://localhost/irods-rest/0.9.3".
#' @param zone_path Zone path of the iRODS server. Defaults to "/tempZone/home".
#' @param dir The directory to use. Default is a temporary directory.
#' @param env Attach exit handlers to this environment. Defaults to the
#'  parent frame (accessed through [parent.frame()]).
#'
#' @return Invisibly returns the original directory.
#' @export
#'
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

  # switch to new iRODS project
  create_irods(host, zone_path, overwrite = TRUE)

  invisible(dir)
}
