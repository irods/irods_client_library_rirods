#' Change/show current working directory
#'
#' Changes iRODS the current working directory (collection). The functions
#' mimic behavior of unix `cd` and `pwd`.
#'
#' @param dir Change the current directory to DIR.  The default DIR is the value
#'  of the HOME shell variable.
#'
#' @return Visibly or invisibly returns the path.
#' @export
#'
#' @examples
#' if(interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authenticate
#' iauth()
#'
#' # default dir
#' icd(".")
#' ipwd()
#'
#'
#' # relative paths work as well
#' icd("/tempZone/home")
#' ipwd()
#'
#' # go back on level lower
#' icd("..")
#' ipwd()
#'
#' # absolute paths work as well
#' icd("/tempZone/home/rods")
#' ipwd()
#' }
icd  <- function(dir) {

  # get current dir
  if (dir  == ".") {
    current_dir <- local(current_dir, envir = .rirods)
  }

  # get level lower
  if (dir  == "..") {
    current_dir <- local(current_dir, envir = .rirods)
    current_dir <- sub(paste0("/", basename(current_dir)), "", current_dir)
    if (current_dir == character(1))
      current_dir <- "/"
  }

  # get requested dir
  if (!dir %in% c(".", "..")) {

    if(!grepl("^\\.{1,2}/", dir)) {

      if (grepl("^\\/", dir)) {
        # absolute path
        current_dir <- dir
      } else {
        # relative path
        current_dir <- paste0(local(current_dir, envir = .rirods), "/", dir)
      }

    } else {
      if(grepl("^\\.{2}/", dir)) {

        # movement relative path
        base_dir <- icd("..")

        current_dir <- paste0(
          base_dir,
          ifelse(base_dir == "/", "", "/"), sub("\\.\\./", "", dir)
        )
      } else if(grepl("^\\.{1}/", dir)) {
        # no movement relative path
        base_dir <- icd(".")

        current_dir <- paste0(
          base_dir,
          ifelse(base_dir == "/", "", "/"), sub("\\./", "", dir)
        )
      }
    }

    # check if irods collection exists
    if (!is_collection(current_dir))
      stop("This is not a directory (collection).", call. = FALSE)

    current_dir
  }

  # store internally
  .rirods$current_dir <- current_dir

  # return location
  invisible(current_dir)
}
#' @rdname icd
#'
#' @export
ipwd <- function() .rirods$current_dir

#' Listing iRODS data objects and collections
#'
#' Recursive listing of a collection, or stat, metadata, and access control
#' information for a given data object.
#'
#' @param logical_path Directory to be listed.
#' @param stat Boolean flag to indicate stat information is desired.
#' @param permissions  Boolean flag to indicate access control information is
#'  desired.
#' @param metadata Boolean flag to indicate metadata is desired.
#' @param offset Number of records to skip for pagination.
#' @param limit Number of records desired per page.
#' @param message In case the collection is empty a message saying so is
#'  returned.
#' @param verbose Show information about the http request and response.
#'
#' @return tibble with logical paths
#' @export
#'
#' @examples
#' if(interactive()) {
#' # authenticate
#' iauth()
#'
#' # list home directory
#' ils()
#' }
ils <- function(
    logical_path = ".",
    stat = FALSE,
    permissions = FALSE,
    metadata = FALSE,
    offset = 0,
    limit = 100,
    message = TRUE,
    verbose = FALSE
) {

  # logical path
  if (logical_path == ".") {
    lpath <- .rirods$current_dir
  } else {
    lpath <- logical_path
  }

  # flags to curl call
  args <- list(
    `logical-path` = lpath,
    stat = as.integer(stat),
    permissions = as.integer(permissions),
    metadata = as.integer(metadata),
    offset = offset,
    limit = limit
  )

  # http call
  out <- irods_rest_call("list", "GET", args, verbose)

  # parse
  out <- httr2::resp_body_json(
    out,
    check_type = FALSE,
    simplifyVector = TRUE
  )$`_embedded` |>
  as.data.frame()

  # metadata reordering
  if (isTRUE(metadata)) {
    try(out <- metadata_reorder(out), silent = TRUE)
  }

  # output
  if (nrow(out) == 0) {
    if (isTRUE(message))
      message("This collection does not contain any objects or collections.")
    invisible(out)
  } else {
    out
  }
}

# reorder metadata if it exists
metadata_reorder <- function(x) {
  x$metadata <- Map(function(x) {x <- x[ ,c("attribute", "value", "units")]; x}, x$metadata)
  x
}

