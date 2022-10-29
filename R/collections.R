#' Create/remove objects in iRODS
#'
#' These functions provide an interface to remove or create objects or
#' collections from the iRODS namespace. By default the objects/collections are
#' moved to the trash collection when removed.
#'
#' @inheritParams iput
#' @param trash Send to trash or delete permanently (default = TRUE).
#' @param recursive Recursively delete contents of a collection
#'  (default = FALSE).
#' @param unregister Unregister data objects instead of deleting them
#'  (default = FALSE).
#' @param collection Indicates that a collection is being created (defaults to
#'  TRUE).
#' @param create_parent_collections Indicates that parent collections of the
#'  destination collection should be created if necessary. Only applicable when
#'  collection = TRUE is used. Defaults to FALSE.
#'
#' @return Invisible object to be removed
#' @export
#'
#' @examples
#' if(interactive()) {
#' # authentication
#' iauth()
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store
#' iput(foo)
#'
#' # check if file is stored
#' ils()
#'
#' # delete object
#' irm("foo", trash = FALSE)
#'
#' # create collection
#' imkdir("a")
#'
#' # check if file is delete
#' ils()
#' }
irm <- function(x, trash = TRUE, recursive = FALSE, unregister = FALSE,
                verbose = FALSE) {

  # logical path
  if (!grepl("/", x)) {
    lpath <- paste0(.rirods$current_dir, "/", x)
  } else {
    lpath <- x
  }

  # flags to curl call
  args <- list(`logical-path` = lpath, `no-trash` = as.integer(trash), recursive = as.integer(recursive))

  # http call
  out <- irods_rest_call("logicalpath", "DELETE", args, verbose)

  # response
  invisible(out)
}
#' @rdname irm
#'
#' @export
imkdir <- function(x, collection = TRUE, create_parent_collections = FALSE,
                   verbose = FALSE) {

  # logical path
  if (grepl("^/", x) && is_collection(x)) {
    lpath <- x
  } else {
    lpath <- paste0(.rirods$current_dir, "/", x)
  }

  # flags to curl call
  args <- list(
    `logical-path` = lpath,
    collection = as.integer(collection),
    `create-parent-collections` = as.integer(create_parent_collections)
  )

  # http call
  out <- irods_rest_call("logicalpath", "POST", args, verbose)

  # response
  invisible(out)
}
