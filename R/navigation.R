#' Get or set current working directory in iRODS
#'
#' `ipwd()` and `icd()` are the iRODS equivalents of `getwd()` and `setwd()`
#' respectively. For example, whereas `getwd()` returns the current working directory
#' in the local system, `ipwd()` returns the current working directory in iRODS.
#'
#' @param dir Collection to set as working directory.
#'
#' @return Invisibly the current directory before the change (same convention as
#'  `setwd()`).
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

  # remove trailing slash
  dir <- gsub("/+$", "", dir)

  # dir at start
  current_dir <- local(current_dir, envir = .rirods)

  # get current dir
  if (dir  == ".") {
    new_dir <- current_dir
  }

  # get level lower
  if (dir  == "..") {
    new_dir <- sub(paste0("/", basename(current_dir)), "", current_dir)
    if (new_dir == character(1))
      new_dir <- "/"
  }

  # get requested dir
  if (!dir %in% c(".", "..")) {

    if(!grepl("^\\.{1,2}/", dir)) {

      if (grepl("^\\/", dir)) {
        # absolute path
        new_dir <- dir
      } else {
        # relative path
        new_dir <- paste0(current_dir, "/", dir)
      }

    } else {

      if(grepl("^\\.{2}/", dir)) {

        # movement relative path
        icd("..")
        base_dir <- local(current_dir, envir = .rirods)

        new_dir <- paste0(
          base_dir,
          ifelse(base_dir == "/", "", "/"), sub("\\.\\./", "", dir)
        )

      } else if(grepl("^\\.{1}/", dir)) {

        # no movement relative path
        new_dir <- paste0(
          current_dir,
          ifelse(current_dir == "/", "", "/"), sub("\\./", "", dir)
        )
      }
    }

    # check if iRODS collection exists
    if (!is_collection(new_dir))
      stop("This is not a directory (collection).", call. = FALSE)

    new_dir
  }

  # store internally
  .rirods$current_dir <- new_dir

  # return location invisibly
  invisible(current_dir)
}

#' @rdname icd
#'
#' @export
ipwd <- function() .rirods$current_dir

#' List iRODS data objects and collections
#'
#' List the contents of a collection, optionally with stat, metadata, and/or
#' access control information for each element in the collection.
#'
#' @param logical_path Path to the collection whose contents are to be listed.
#'    By default this is the current working directory (see `ipwd()`).
#' @param stat Whether stat information should be included. Defaults to `FALSE`.
#' @param permissions Whether access control information should be included.
#'    Defaults to `FALSE`.
#' @param metadata Whether metadata information should be included. Defaults to `FALSE`.
#' @param offset Number of records to skip for pagination. Defaults to 0.
#' @param limit Number of records to show per page. Defaults to 100.
#' @param message Whether a message should be printed when the collection is empty.
#' @param verbose Whether information should be printed about the HTTP request and response.
#'
#' @return Dataframe with logical paths and, if requested, additional information.
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
#' # list home directory
#' ils()
#'
#' # list a different directory
#' ils('/tempZone/home/rods/some_collection')
#'
#' # show metadata
#' ils(metadata = TRUE)
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
  # logical path
  if (logical_path == ".") {
    lpath <- .rirods$current_dir
  } else if (startsWith(logical_path, "/")) {
    lpath <- logical_path
  } else {
    lpath <- file.path(.rirods$current_dir, logical_path)
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

