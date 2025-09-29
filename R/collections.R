#' Remove Data Objects or Collections in iRODS
#'
#' This is the equivalent of [file.remove()], but applied to an item inside
#'  iRODS.
#'
#' @param logical_path Path to the data object or collection to remove.
#' @param force Whether the data object or collection should be deleted
#'    permanently. If `FALSE`, it is sent to the trash collection. Defaults to
#'   `TRUE`.
#' @param recursive If a collection is provided, whether its contents should
#'     also be removed. If a collection is not empty and `recursive` is `FALSE`
#'    , it cannot be deleted. Defaults to `FALSE`.
#' @param catalog_only Whether to remove only the catalog entry. Defaults to
#'    `FALSE`.
#' @param verbose Whether information should be printed about the HTTP request
#'    and response. Defaults to `FALSE`.
#'
#'
#' @seealso
#'  [imkdir()] for creating collections,
#'  [file.remove()] for an R equivalent.
#'
#' @return Invisibly the HTTP call.
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#' \dontshow{
#' .old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
#' Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
#' }
#' # connect project to server
#' \Sexpr[stage=build, results=rd]{paste0("create_irods(\"", rirods:::.irods_host, "\")")}
#'
#' # authenticate
#' iauth("rods", "rods")
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store
#' isaveRDS(foo, "foo.rds")
#'
#' # check if file is stored
#' ils()
#'
#' # delete object
#' irm("foo.rds", force = TRUE)
#'
#' # check if file is deleted
#' ils()
#' \dontshow{
#' Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
#' }
irm <- function(logical_path, force = TRUE, recursive = FALSE,
                catalog_only = FALSE,
                verbose = FALSE) {

  logical_path <- get_absolute_lpath(logical_path)

  # flags to curl call
  args <- list(
    op = "remove",
    lpath = logical_path,
    recurse = as.integer(recursive),
    `no-trash` = as.integer(force)
  )

  if (is_collection(logical_path)) {
    out <- irm_("collections", args, verbose)
  } else if (is_object(logical_path)) {
    args$`catalog-only` <- as.integer(catalog_only)
    out <- irm_("data-objects", args, verbose)
  } else {
    stop("Logical path does not resolve to data object or collection.", call. = FALSE)
  }

  invisible(out)
}

irm_ <- function(endpoint, args, verbose) {
  irods_http_call(endpoint, "POST", args, verbose) |>
    httr2::req_perform()
}

#' Create a New Collection in iRODS
#'
#' This is the equivalent to [dir.create()], but creating a collection in iRODS
#' instead of a local directory.
#'
#' @param logical_path Path to the collection to create, relative to the current
#'   working collection (see [ipwd()]).
#' @param create_parent_collections Whether parent collections should be created
#'   when necessary. Defaults to `FALSE`.
#' @param overwrite Whether the existing collection should be overwritten
#'   if it exists. Defaults to `FALSE`.
#' @param verbose Whether information about the HTTP request and response
#'  should be printed. Defaults to `FALSE`.
#'
#' @seealso
#'  [irm()] for removing collections,
#'  [dir.create()] for an R equivalent.
#'
#' @return Invisibly the HTTP request.
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#' \dontshow{
#' .old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
#' Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
#' }
#' # connect project to server
#' \Sexpr[stage=build, results=rd]{paste0("create_irods(\"", rirods:::.irods_host, "\")")}
#'
#' # authentication
#' iauth("rods", "rods")
#'
#' # list all object and collection in the current collection of iRODS
#' ils()
#'
#' # create a new collection
#' imkdir("new_collection")
#'
#' # check if it is there
#' ils()
#'
#' # and move to the new directory
#' icd("new_collection")
#'
#' # remove collection
#' icd("..")
#' irm("new_collection", force = TRUE, recursive = TRUE)
#' \dontshow{
#' Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
#' }
imkdir <- function(
  logical_path,
  create_parent_collections = FALSE,
  overwrite = FALSE,
  verbose = FALSE
) {


  logical_path <- get_absolute_lpath(logical_path, write = TRUE)
  stop_irods_overwrite(overwrite, logical_path)

  # flags to curl call
  args <- list(
    op = "create",
    lpath = logical_path,
    `create-intermediates` = as.integer(create_parent_collections)
  )

  out <- irods_http_call("collections", "POST", args, verbose) |>
    httr2::req_perform()

  invisible(out)
}
