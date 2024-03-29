get_server_info <- function(verbose =  FALSE) {
  irods_http_call("info", "GET", list(), verbose = verbose) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

has_irods_conf <- function() {
  file.exists(path_to_irods_conf())
}

# create package configuration directory
create_config_dir <- function(path_to_config_dir) {
  if (!dir.exists(path_to_config_dir)) {
    dir.create(path_to_config_dir, recursive = TRUE)
  }
}

path_to_irods_conf <- function() {
  path_to_config_dir <- rappdirs::user_config_dir("rirods")
  create_config_dir(path_to_config_dir)
  file.path(path_to_config_dir, "conf-irods.json")
}

find_irods_file <- function(what = NULL) {

  check_irods_conf()
  # read irods file
  x <- jsonlite::fromJSON(path_to_irods_conf())
  # find line
  if (!is.null(what))
    x[[what]]
  else
    x
}

check_irods_conf <- function() {

  if (!has_irods_conf()) {
    stop("Can't find iRODS configuration file. Please use `create_irods()`.",
         call. = FALSE)
  } else {
    # get iRODS configuration file
    irods_conf_file <- path_to_irods_conf()
  }

  # check content
  content <- try(jsonlite::fromJSON(path_to_irods_conf()), silent = TRUE)
  if (inherits(content, "try-error") || length(content) < 1) {
    stop("iRODS configuration file is corrupted. Create a new configuration ",
         "file with `create_irods()`?", call. = FALSE)
  }

  invisible(irods_conf_file)
}
