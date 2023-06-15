#' Generate IRODS Configuration File
#'
#' This will create an iRODS configuration file containing information about the
#' iRODS server. Once the file has been created, future sessions
#' connect again with the same iRODS server without further intervention.
#'
#' The configuration file is located in the user-specific configuration
#' directory. This destination is set with R_USER_CONFIG_DIR if set. Otherwise,
#' it follows platform conventions (see also [rappdirs::user_config_dir()]).
#'
#' @param host URL of host.
#' @param zone_path Path to the zone of the iRODS server
#'    (e.g., "/tempZone/home").
#' @param overwrite Overwrite existing iRODS configuration file. Defaults to
#'    `FALSE`.
#'
#' @return Invisibly, the path to the iRODS configuration file.
#' @export
#'
create_irods <- function(host, zone_path, overwrite = FALSE) {

  path <- path_to_irods_conf()

  # check for existence of iRODS configuration file
  if (interactive() && file.exists(path) && isFALSE(overwrite))
    stop(
      "iRODS configuration file already exists. If you want to overwrite this ",
      "file then set `overwrite` to TRUE.",
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
