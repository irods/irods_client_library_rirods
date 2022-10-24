#' Generate IRODS project file
#'
#' This will create an irods project file containing information about the
#' iRODS server.
#'
#' @param host URL of host.
#' @param path Path of project (defaults to current directory).
#' @param overwrite Overwrite existing irods file (defaults to `FALSE`).
#'
#' @return Invisibly returns path to irods file.
#' @export
#'
#' @examples
#' if(interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.2")
#' }
create_irods <- function(host, path = ".", overwrite = FALSE) {
  # project name
  name <- basename(getwd())
  path <- file.path(path, paste0(name, ".irods"))
  if (file.exists(path) && isFALSE(overwrite))
    stop("Irods file alread exists. If you want to overwrite this file then set `overwrite` to TRUE.", call. = FALSE)
  # create file
  file.create(path)
  cat(
    paste0("host: ", host),
    sep = "\n",
    file = path
  )

  # path
  invisible(path)
}
