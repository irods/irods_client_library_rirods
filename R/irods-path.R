make_irods_base_path <- function() {
  check_irods_conf()
  if (!is.null(find_irods_file("irods_zone"))) {
    if (.rirods$user_role == "rodsuser") {
      paste0("/", find_irods_file("irods_zone"), "/home/", .rirods$user)
    } else if (.rirods$user_role == "rodsadmin") {
      paste0("/", find_irods_file("irods_zone"), "/home")
    } else {
      stop("User role unkown", call. = FALSE)
    }

  } else {
    stop("iRODS zone unkown", call. = FALSE)
  }
}

get_absolute_lpath <- function(lpath, write = FALSE, safely = TRUE) {

  if (!grepl("^/" , lpath)) {
    # default zone_path writable by user
    zpath <- ipwd()
    # separate lpath in pieces if need
    x <- strsplit(lpath, "/", fixed = TRUE)[[1]]
    # then expand
    lpath <- Reduce(function(x, y) { paste(x, y, sep = "/") }, c(zpath, x))
  }

  if (isTRUE(safely)) {
    if (isTRUE(write)) {
      is_lpath <- lpath_exists(strsplit(ipwd(), lpath)[[1]])
    } else {
      is_lpath <- lpath_exists(lpath)
    }
    if (!is_lpath) {
      stop("Logical path [", lpath,"] is not accessible.", call. = FALSE)
    }
  }

  lpath
}

# stop overwriting
stop_irods_overwrite <- function(overwrite, lpath) {
  is_lpath <- lpath_exists(lpath)
  if (isFALSE(overwrite) && is_lpath) {
    stop(
      "Object [",
      lpath,
      "] already exists.",
      " Set `overwrite = TRUE` to explicitly overwrite the object.",
      call. = FALSE
    )
  }
}

# check if iRODS collection exists
is_collection <- function(lpath) {
  lpath <- get_absolute_lpath(lpath)
  irods_stats <- try(get_stat_collections(lpath), silent = TRUE)
  if (inherits(irods_stats, "try-error")) {
    FALSE
  } else {
    irods_stats$type == "collection"
  }
}

# check if iRODS data object exists
is_object <- function(lpath) {
  lpath <- get_absolute_lpath(lpath)
  irods_stats <- try(get_stat_data_objects(lpath), silent = TRUE)
  if (inherits(irods_stats, "try-error")) {
    FALSE
  } else {
    irods_stats$type == "data_object"
  }
}

# check if iRODS path exists
lpath_exists <- function(lpath, write = FALSE) {
  # check connection
  if (!is_connected_irods()) stop("Not connected to iRODS.", call. = FALSE)

  # reference paths
  all_lpaths <- ils(make_irods_base_path(), recurse = 1) |>
    as.data.frame() |>
    rbind(make_irods_base_path())

  if (isFALSE(write)) # in case of TRUE `strsplit` ensures absolute path
    lpath <- get_absolute_lpath(lpath, safely = FALSE)

  lpath %in% all_lpaths[[1]]
}


get_stat_collections <- function(lpath, verbose = FALSE) {
  make_stat(lpath, "collections", verbose)
}

get_stat_data_objects <- function(lpath, verbose = FALSE) {
  make_stat(lpath, "data-objects", verbose)
}

make_stat <- function(lpath, endpoint, verbose) {
  lpath <- get_absolute_lpath(lpath)
  args <- list(
    op = "stat",
    lpath = lpath
  )
  irods_http_call(endpoint, "GET", args, verbose) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    as.data.frame()
}
