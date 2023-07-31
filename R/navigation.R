#' Get or Set Current Working Directory in iRODS
#'
#' `ipwd()` and `icd()` are the iRODS equivalents of [getwd()] and [setwd()]
#' respectively. For example, whereas `getwd()` returns the current working directory
#' in the local system, `ipwd()` returns the current working directory in iRODS.
#'
#' @param dir Collection to set as working directory.
#'
#' @return Invisibly the current directory before the change (same convention as
#'  `setwd()`).
#' @seealso
#'  [setwd()] and [getwd()] for R equivalents,
#'  [ils()] for listing collections and objects in iRODS.
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#'
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' # use_irods_demo()
#'
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authenticate
#' iauth("rods", "rods")
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
#'
#' # back home
#' icd("/tempZone/home")
#'
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

#' List iRODS Data Objects and Collections
#'
#' List the contents of a collection, optionally with stat, metadata, and/or
#' access control information for each element in the collection.
#'
#' @param logical_path Path to the collection whose contents are to be listed.
#'    By default this is the current working collection (see [ipwd()]).
#' @param stat Whether stat information should be included. Defaults to `FALSE`.
#' @param permissions Whether access control information should be included.
#'    Defaults to `FALSE`.
#' @param metadata Whether metadata information should be included. Defaults to
#'    `FALSE`.
#' @param offset Number of records to skip for pagination. Defaults to 0.
#' @param limit Number of records to show per page. Defaults to 100.
#' @param message Whether a message should be printed when the collection is
#'    empty. Defaults to `TRUE`.
#' @param verbose Whether information should be printed about the HTTP request
#'    and response. Defaults to `FALSE`.
#'
#' @return Dataframe with logical paths and, if requested, additional
#'    information.
#' @seealso
#'  [ipwd()] for finding the working collection,
#'  [ipwd()] for setting the working collection, and
#'  [list.files()] for an R equivalent.
#'
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#'
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' # use_irods_demo()
#'
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authenticate
#' iauth("rods", "rods")
#'
#' # list home directory
#' ils()
#'
#' # make collection
#' imkdir("some_collection")
#'
#' # list a different directory
#' ils("/tempZone/home/rods/some_collection")
#'
#' # show metadata
#' ils(metadata = TRUE)
#'
#' # delete `some_collection`
#' irm("some_collection", force = TRUE, recursive = TRUE)
#'
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
  )$`_embedded`
  if (isTRUE(stat)) {
    converted_last_write_time <- as.POSIXct(
      as.numeric(out$status_information$last_write_time),
      origin = "1970-01-01")
    out$status_information$last_write_time <- converted_last_write_time
    if ("size" %in% colnames(out$status_information)) {
      out$status_information$size <- as.numeric(out$status_information$size)
    }
  }
  out <- new_irods_df(out)

  # metadata reordering
  if (isTRUE(metadata)) {
    try(out <- metadata_reorder(out), silent = TRUE)
  }

  # output
  out
}

# reorder metadata if it exists
metadata_reorder <- function(x) {
  x$metadata <- Map(
    function(x) if (length(x) > 0) x[ ,c("attribute", "value", "units")] else x,
    x$metadata
  )
  x
}
