#' Get or Set Current Working Directory (Collection) in iRODS
#'
#' `ipwd()` and `icd()` are the iRODS equivalents of [getwd()] and [setwd()]
#' respectively. For example, whereas `getwd()` returns the current working directory
#' in the local system, `ipwd()` returns the current working collection in iRODS.
#'
#' @param dir Path to set as working collection.
#'
#' @return Invisibly the current collection before the change (same convention as
#'  `setwd()`).
#' @seealso
#'  [setwd()] and [getwd()] for R equivalents,
#'  [ils()] for listing collections and objects in iRODS.
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
#' iauth("rods", "rods", "rodsadmin")
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
#' \dontshow{
#' Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
#' }
icd <- function(dir) {

  # check connection
  if (!is_connected_irods()) stop("Not connected to iRODS.", call. = FALSE)

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
#' @param offset Number of records to skip for pagination. Deprecated.
#' @param recurse Recursively list. Defaults to `FALSE`.
#' @param ticket A valid iRODS ticket string. Defaults to `NULL`.
#' @param message Show message when empty collection. Default to `FALSE`.
#' @param limit Number of records to show. To show all records, provide `NULL`.
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
#' \dontshow{
#' Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
#' }
ils <- function(
  logical_path = ".",
  stat = FALSE,
  permissions = FALSE,
  metadata = FALSE,
  offset = numeric(1),
  limit = find_irods_file("max_number_of_rows_per_catalog_query"),
  recurse = FALSE,
  ticket = NULL,
  message = TRUE,
  verbose = FALSE
) {
  # logical path
  if (logical_path == ".") {
    lpath <- .rirods$current_dir
  } else if (startsWith(logical_path, "/")) {
    lpath <- logical_path
  } else {
    lpath <- paste0(.rirods$current_dir, "/", logical_path)
  }

  # deprecate arguments
  if (!missing("offset"))
    warning("Argument `offset` is deprecated")

  # flags to curl call
  args <- list(
    op = "list",
    lpath = lpath,
    recurse = as.integer(recurse),
    ticket = ticket
  )

  out <- irods_http_call("collections", "GET", args, verbose) |>
    httr2::req_perform()

  lpaths <- httr2::resp_body_json(out, check_type = FALSE, simplifyVector = TRUE)$entries

  irods_zone_overview <- data.frame(logical_path = lpaths)

  if (isTRUE(stat) | isTRUE(permissions)) {
    ils_stat_dataframe <- make_ils_stat(irods_zone_overview$logical_path)
    if (isFALSE(stat)) {
      permissions_columns <- names(ils_stat_dataframe)[grepl("permission", names(ils_stat_dataframe))]
      if ("inheritance_enabled" %in% names(ils_stat_dataframe)) {
        permissions_columns <- c(permissions_columns, "inheritance_enabled")
      }
      ils_stat_dataframe <- ils_stat_dataframe[permissions_columns]
    }
    irods_zone_overview <- cbind(irods_zone_overview, ils_stat_dataframe)
  }

  if (isTRUE(metadata)) {
    ils_meta_dataframe <- make_ils_metadata(lpath)
    if (!is.null(ils_meta_dataframe)) {
      irods_zone_overview <-
        merge(irods_zone_overview, ils_meta_dataframe, all.x = TRUE)
    }
  }

  if (!is.null(limit)) {
    irods_zone_overview <- limit_maximum_number_of_rows_catalog(irods_zone_overview, limit)
  }
  new_irods_df(irods_zone_overview)
}

make_ils_stat <- function(lpaths) {
  stat_list <- lapply(lpaths, get_stat)
  Reduce(rbind_unequal_shaped_dataframes, stat_list)
}

make_ils_metadata <- function(lpath) {
  metadata_collections <-
    iquery(collection_metadata(lpath, recurse = TRUE))
  metadata_data_objects <- iquery(data_object_metadata(lpath))
  if (length(metadata_collections) == 0 && length(metadata_data_objects) == 0) {
    message("No metadata")
    return(NULL)
  } else if (length(metadata_data_objects) == 0) {
    metadata <- metadata_collections
  } else if (length(metadata_collections) == 0) {
    metadata <- metadata_data_objects
  } else {
    metadata <-
      rbind_unequal_shaped_dataframes(metadata_collections, metadata_data_objects)
  }
  data.frame(
    logical_path = paste0(metadata[["COLL_NAME"]],  ifelse(
      is.na(metadata[["DATA_NAME"]]), "", paste0("/", metadata[["DATA_NAME"]])
    )),
    attribute = ifelse(
      all(is.na(metadata[["META_COLL_ATTR_NAME"]])) ||
        all(is.null(metadata[["META_COLL_ATTR_NAME"]])),
     stats::na.omit(metadata["META_DATA_ATTR_NAME"]),
     stats::na.omit(metadata["META_COLL_ATTR_NAME"]))[[1]],
    value = ifelse(
      all(is.na(metadata[["META_COLL_ATTR_VALUE"]])) ||
        all(is.null(metadata[["META_COLL_ATTR_VALUE"]])),
     stats::na.omit(metadata["META_DATA_ATTR_VALUE"]),
     stats::na.omit(metadata["META_COLL_ATTR_VALUE"]))[[1]],
    units = ifelse(
      all(is.na(metadata[["META_COLL_ATTR_UNITS"]])) ||
        all(is.null(metadata[["META_COLL_ATTR_UNITS"]])),
     stats::na.omit(metadata["META_DATA_ATTR_UNITS"]),
     stats::na.omit(metadata["META_COLL_ATTR_UNITS"]))[[1]]
  )
}

rbind_unequal_shaped_dataframes <- function(df1, df2) {
  df1[setdiff(names(df2), names(df1))] <- NA_character_
  df2[setdiff(names(df1), names(df2))] <- NA_character_
  rbind(df1, df2)
}

get_stat <- function(lpath) {
  stat_collection <- try(get_stat_collections(lpath), silent = TRUE)
  stat_data_object <- try(get_stat_data_objects(lpath), silent = TRUE)
  if (stat_collection$status_code == -170000L) {
    return(stat_data_object)
  } else if (stat_data_object$status_code == -171000L) {
    return(stat_collection)
  }
}
