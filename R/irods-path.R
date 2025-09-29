make_irods_home <- function() {
  irods_home <- find_irods_file("irods_home")
  zone <- make_irods_base_path()

  if (length(irods_home) == 0) {
    return(zone)
  }

  if (!startsWith(irods_home, zone)) {
    irods_home <- paste0(zone, gsub("^/?(.+)/?", "/\\1", irods_home))
  }

  if (lpath_exists(irods_home)) {
    irods_home
  } else {
    warning(sprintf("%s does not exist, defaulting to %s", irods_home, base_home))
    zone
  }
}

make_irods_base_path <- function() {
  sprintf("/%s/home", .rirods$zone)
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
    path_to_check <- if (isTRUE(write)) strsplit(ipwd(), lpath)[[1]] else lpath
    is_lpath <- lpath_exists(path_to_check, write=TRUE) # with write=FALSE we have a loop
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
  if (inherits(irods_stats, "try-error") || irods_stats$status_code == -170000L) {
    FALSE
  } else {
    irods_stats$type == "collection"
  }
}

# check if iRODS data object exists
is_object <- function(lpath) {
  lpath <- get_absolute_lpath(lpath)
  irods_stats <- try(get_stat_data_objects(lpath), silent = TRUE)
  if (inherits(irods_stats, "try-error") || irods_stats$status_code == -171000L) {
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
  all_lpaths <- ils(make_irods_base_path(), recurse = 1, limit=NULL) |>
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
