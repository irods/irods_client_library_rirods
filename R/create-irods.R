#' Generate IRODS project file
#'
#' This will create an irods project file containing information about the
#' iRODS server. It allows for working with an iRODS server in the particular
#' context of a working directory and source files. Furthermore, future sessions
#' connect again with the same iRODS server without further intervention.
#'
#' @param host URL of host.
#' @param zone_path Zonepath of the iRODS server (e.g., "/tempZone/home").
#' @param path Path of project (defaults to current directory).
#' @param overwrite Overwrite existing irods file (defaults to `FALSE`).
#'
#' @return Invisibly returns path to irods file.
#' @export
#'
#' @examples
#' if(interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.2", "/tempZone/home")
#' }
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
      "Irods file alread exists. If you want to overwrite this file then",
      "set `overwrite` to TRUE.",
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
