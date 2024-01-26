#' Coerce to a Data Frame
#'
#' Coerce iRODS Zone information class to [data.frame()].
#'
#' @param x `irods_df` class object.
#' @param ... Currently not implemented
#'
#' @return Returns a `data.frame`. Note, that the
#' columns of metadata consists of a list of data frames, and status_information
#' and permission_information consist of data frames.
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
#' create_irods("http://localhost:9001/irods-http-api/0.1.0")
#'
#' # authenticate
#' iauth("rods", "rods")
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store data in iRODS
#' isaveRDS(foo, "foo.rds")
#'
#' # add some metadata
#' imeta(
#'   "foo.rds",
#'   "data_object",
#'   operations =
#'     data.frame(operation = "add", attribute = "foo", value = "bar",
#'       units = "baz")
#' )
#'
#' # iRODS Zone with metadata
#' irods_zone <- ils(metadata = TRUE)
#'
#' # check class
#' class(irods_zone)
#'
#' # coerce into `data.frame` and extract metadata of "foo.rds"
#' irods_zone <- as.data.frame(irods_zone)
#' irods_zone[basename(irods_zone$logical_path) == "foo.rds", "metadata"]
#'
#' # delete object
#' irm("foo.rds", force = TRUE)
#'
as.data.frame.irods_df <- function(x, ...) {
  class(x) <- "data.frame"
  x
}
#' iRODS Zone Information Class
#'
#' @keywords internal
#' @param x list with iRODS Zone information.
#'
#' @return `irods_df` class object.
new_irods_df <- function(x = list()) {
  validate_irods_df(x)
  structure(x, class = "irods_df")
}

# helpers to validate the `irods_df` class
validate_irods_df <- function(x) {

  if (!is.data.frame(x))
    stop("iRODS class should inherit from `data.frame`.")

  irods_attributes <-
    c("logical_path",
      "inheritance_enabled",
      "status_code",
      "modified_at",
      "permissions.name",
      "permissions.perm",
      "permissions.type",
      "permissions.zone",
      "registered",
      "type",
      "checksum",
      "size",
      "attribute",
      "value",
      "units"

      )

  if (length(x) != 0L && !all(names(x) %in% irods_attributes))
    stop("Names of `list` are unknown iRODS attributes.",
         call. = FALSE)
  x
}

