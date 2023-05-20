#' Remove data objects or collections in iRODS.
#'
#' This is the equivalent of `file.remove()`, but applied to an item inside iRODS.
#'
#' @param logical_path Path to the data object or collection to remove.
#' @param force Whether the data object or collection should be deleted permanently.
#'    If `FALSE`, it is sent to the trash collection.
#' @param recursive If a collection is provided, whether its contents should also be
#'    removed. If a collection is not empty and `recursive` is `FALSE`, it cannot
#'    be deleted.
#' @param verbose Whether information should be printed about the HTTP request and response.
#'
#' @return Invisibly the HTTP call.
#' @export
#'
#' @examples
#' if (interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authentication
#' iauth()
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store
#' iput(foo, "foo.rds")
#'
#' # check if file is stored
#' ils()
#'
#' # delete object
#' irm("foo.rds", force = TRUE)
#' iquery("SELECT COLL_NAME, DATA_NAME WHERE DATA_NAME LIKE 'foo%'")
#' }
irm <- function(logical_path, force = TRUE, recursive = FALSE,
                verbose = FALSE) {

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path, open = "read")

  # flags to curl call
  args <- list(
    `logical-path` = logical_path,
    `no-trash` = as.integer(force),
    recursive = as.integer(recursive)
  )

  # http call
  out <- irods_rest_call("logicalpath", "DELETE", args, verbose)

  # response
  invisible(out)
}

#' Create a new collection in iRODS
#'
#' This is the equivalent to `dir.create()`, but creating a collection in iRODS
#' instead of a local directory.
#'
#' @param logical_path Path to the collection to create, relative to the current
#'   working directory (see `ipwd()`).
#' @param collection Whether a collection is being created. Defaults to `TRUE`.
#' @param create_parent_collections Whether parent collections should be created
#'   when necessary.
#' @param verbose Whether information about the HTTP request and response should be printed.
#'
#' @return Invisibly the HTTP request.
#' @export
#'
#' @examples
#' if (interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authentication
#' iauth()
#'
#' ils()
#' imkdir("new_collection")
#' ils()
#' icd("new_collection")
#' }
imkdir <- function(logical_path, collection = TRUE,
                   create_parent_collections = FALSE, verbose = FALSE) {
  # NOTE this function will be made into an internal function create_item()
  # Then `imkdir()` will call this function with collection = TRUE
  # and `itouch()` will call this function with collection = FALSE and create_parent_collections = FALSE

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # flags to curl call
  args <- list(
    `logical-path` = logical_path,
    collection = as.integer(collection),
    `create-parent-collections` = as.integer(create_parent_collections)
  )

  # http call
  out <- irods_rest_call("logicalpath", "POST", args, verbose)

  # response
  invisible(out)
}
