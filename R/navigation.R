#' Retrieve an object from iRODS
#'
#' @param dir Change the current directory to DIR.  The default DIR is the value
#'  of the HOME shell variable.
#'
#' @return invisibly returns the path
#' @export
#'
#' @examples
#'
#' # authenticate
#' auth()
#'
#' # default dir
#' icd(".")
#' ipwd()
#'
#'
#' # some other dir
#' icd("/tempZone/home")
#' ipwd()
#'
#' # go back on level lower
#' icd("..")
#' ipwd()
#'
#' # relative paths work as well
#' icd("../home/public")
#' ipwd()
#'
icd  <- function(dir) {

  # get current dir
  if (dir  == ".") {
    current_dir <- local(current_dir, envir = .rirods2)
  }

  # get level lower
  if (dir  == "..") {
    current_dir <- local(current_dir, envir = .rirods2)
    current_dir <- sub(paste0("/", basename(current_dir)), "", current_dir)
    if (current_dir == character(1)) current_dir <- "/"
  }

  # get requested dir
  if (!dir %in% c(".", "..")) {

    if(!grepl("\\.\\./", dir)) {
      current_dir <- dir
    } else {
      base_dir <- icd(".")
      current_dir <- paste0(base_dir, ifelse(base_dir == "/", "", "/"), sub("\\.\\./", "", dir))
    }

    # check if exist
    idir <- try(ils(path = current_dir, message = FALSE), silent = TRUE)
    if (inherits(idir, "try-error")) stop("Dir does not exist.")

    current_dir
  }

  # store internally
  .rirods2$current_dir <- current_dir

  # return location
  invisible(current_dir)
}
#' @rdname icd
#'
#' @export
ipwd <- function() .rirods2$current_dir

#' Listing iRODS data objects and collections
#'
#' Recursive listing of a collection, or stat, metadata, and access control
#' information for a given data object.
#'
#' @inheritParams iadmin
#' @param path Directory to be listed.
#' @param stat Boolean flag to indicate stat information is desired.
#' @param permissions  Boolean flag to indicate access control information is
#'  desired.
#' @param metadata Boolean flag to indicate metadata is desired.
#' @param offset Number of records to skip for pagination.
#' @param limit Number of records desired per page.
#' @param message In case the collection is empty a message saying so is
#'  returned.
#'
#' @return tibble with logical paths
#' @export
#'
#' @examples
#'
#' # authenticate
#' auth()
#'
#' # list home directory
#' ils()
ils <- function(
    host = "http://localhost/irods-rest/0.9.2",
    path = ".",
    stat = FALSE,
    permissions = FALSE,
    metadata = FALSE,
    offset = 0,
    limit = 100,
    message = TRUE
) {

  # why does path  == "/" fail???

  token <- local(token, envir = .rirods2)
  if (path == ".") lpath <- .rirods2$current_dir else lpath <- path

  # request
  req <- httr2::request(host) |>
    httr2::req_url_path_append("list") |>
    httr2::req_headers(Authorization = token) |>
    httr2::req_url_query(
      `logical-path` = lpath,
      stat = as.integer(stat),
      permissions = as.integer(permissions),
      metadata = as.integer(metadata),
      offset = offset,
      limit = limit
    )

  # response
  resp <- httr2::req_perform(req)

  # parse
  out <- httr2::resp_body_json(
    resp,
    check_type = FALSE,
    simplifyVector = TRUE
  )$`_embedded` |>
    as.data.frame()

  if (nrow(out) == 0) {
    if (isTRUE(message)) message("This collection does not contain any objects or collections.")
    invisible(out)
  } else {
    out
  }
}
