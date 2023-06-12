#' Predicate for iRODS Connectivity
#'
#' A predicate to check whether you are currently connected to an iRODS server.
#'
#' @param ... Currently not implemented.
#' @return Boolean whether or not a connection to iRODS exists.
#' @export
#'
#' @examples
#' is_connected_irods()
is_connected_irods <- function(...) {

  lpath <- try(.rirods$token, silent = TRUE)

  if (inherits(lpath, "try-error")) FALSE else TRUE
}

find_irods_file <- function(what) {

  # find irods file
  irods <- list.files(".", "\\.irods$")
  if (length(irods) == 0) {
    stop("Can't connect with iRODS server. Did you supply the correct host",
         "name with `create_irods()`?", call. = FALSE)
  } else if (length(irods) > 1) {
    stop("You appear to have more than one iRODS project file. ",
         "Please delete one before proceeding.", call. = FALSE)
  }

  # read irods file
  x <- readLines(irods)
  # find line
  x <- x[grepl(what, x)]
  # error if not found
  if (length(x) == 0)
    stop("iRODS project file is incomplete.", call. = FALSE)
  # extract information
  sub(paste0(what, ": "), "", x)

}
