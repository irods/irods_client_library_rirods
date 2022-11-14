is_connected_irods <- function() {

  lpath <- try(.rirods$token, silent = TRUE)

  if (inherits(lpath, "try-error")) FALSE else TRUE
}

find_irods_file <- function(what) {

  # find irods file
  irods <- list.files(".", "\\.irods$")
  if (length(irods) == 0)
    stop("Can't connect with iRODS server. Did you supply the correct host",
         "name with `create_irods()`?", call. = FALSE)

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
