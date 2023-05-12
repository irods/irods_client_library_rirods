#' Generate IRODS project file
#'
#' This will create an iRODS project file containing information about the
#' iRODS server. Once the file has been created, future sessions
#' connect again with the same iRODS server without further intervention.
#'
#' @param host URL of host.
#' @param zone_path Path to the zone of the iRODS server (e.g., "/tempZone/home").
#' @param path Path of project. Defaults to the top directory of the zone..
#' @param overwrite Overwrite existing iRODS project file. Defaults to `FALSE`.
#'
#' @return Invisibly, the path to the iRODS project file.
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
