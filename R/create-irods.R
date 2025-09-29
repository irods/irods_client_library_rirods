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
#' @param irods_home Path to the initial working collection. Once the user is authenticated,
#'   if no other absolute or relative path has been requested here, it will default
#'   to `/zoneName/home`.
#' @param zone_path Deprecated
#' @param overwrite Overwrite existing iRODS configuration file. Defaults to
#'    `FALSE`.
#'
#' @return Invisibly, the path to the iRODS configuration file.
#' @export
#'
create_irods <- function(host, irods_home = character(0), zone_path = character(1), overwrite = FALSE) {

  if (!missing("zone_path"))
    warning("Argument `zone_path` is deprecated")

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
  write(
    jsonlite::toJSON(list(host = host, irods_home = irods_home), auto_unbox = TRUE, pretty = TRUE),
    file = path
  )

  # path
  invisible(path)
}
