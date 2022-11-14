get_absolute_lpath <- function(lpath, data_type = "data_object", open = "write") {

  if (!grepl("^/" , lpath)) {
    # default zone_path writable by user
    zpath <- ipwd()
    # separate lpath in piece if need
    x <- strsplit(lpath, "/", fixed = TRUE)[[1]]
    # then expand
    lpath <- Reduce(function(x, y) { paste(x, y, sep = "/") }, c(zpath, x))
  }

  # check if logical path exists
  if (open == "read") {
    if (data_type == "data_object") {
      is_object(lpath)
    } else if (data_type == "collection") {
      is_collection(lpath)
    } else {
      stop("`open` only accepts \"write\" or \"read\".", call. = FALSE)
    }
  } else if (open == "write") {
    # could add some checks on irods file names in the future
  } else {
    stop("`data_type` only accepts \"data_object\" or \"collection\".", call. = FALSE)
  }

  # return
  lpath
}

# # Construct Logical Path to File
# file_lpath <- function(...) {
#   Reduce(function(x, y) { paste(x, y, sep = "/") }, list(...))
# }

# stop overwriting
stop_irods_overwrite <- function(overwrite, lpath) {
  if (isFALSE(overwrite)) {
    if (lpath_exists(lpath)) {
      stop(
        "Object [",
        lpath,
        "] already exists.",
        " Set `overwrite = TRUE` to explicitly overwrite the object.",
        call. = FALSE
      )
    }
  }
}


# check if irods collection exists
is_collection <- function(lpath) {

  # initial check
  if (lpath_exists(lpath))
    out <- ils(lpath, message = FALSE)
  else
    stop("Logical path [", lpath,"] is not accessible.", call. = FALSE)

  # this cannot be a collection
  if (lpath %in% out$logical_path && out$type == "data_object") {
    FALSE
  } else {
    TRUE
  }

}

# check if irods data object exists
is_object <- function(lpath) !is_collection(lpath)

# check if irods path exists
lpath_exists <- function(lpath) {

  # check connection
  if (!is_connected_irods()) stop("Not connected to iRODS.", call. = FALSE)

  # check path
  lpath <- try(ils(lpath, message = FALSE), silent = TRUE)

  if (inherits(lpath, "try-error")) FALSE else TRUE
}
