#' Delete an object from iRODS
#'
#' @inheritParams iput
#' @param trash Send to trash or delete permanently (default = TRUE).
#' @param recursive Recursively delete contents of a collection
#'  (default = FALSE).
#' @param unregister Unregister data objects instead of deleting them
#'  (default = FALSE).
#'
#' @return Invisible object to be removed
#' @export
#'
#' @examples
#'
#' # authentication
#' iauth("bobby", "passWORD")
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
#' # check if file is delete
#' ils()
irm <- function(x, trash = TRUE, recursive = FALSE, unregister = FALSE,
                verbose = FALSE) {

  # logical path
  if (!grepl("/", x)) {
    lpath <- paste0(.rirods2$current_dir, "/", x)
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

