has_irods_conf <- function() {
  file.exists(path_to_irods_conf())
}

# create package configuration directory
create_config_dir <- function(path_to_config_dir) {

  if (!dir.exists(path_to_config_dir)) {
    # windows uses author name and app name as path
    if (Sys.info()[["sysname"]] == "Windows") {
      dir.create(dirname(path_to_config_dir))
    }
    dir.create(path_to_config_dir)
  }
}

path_to_irods_conf <- function() {
  path_to_config_dir <- rappdirs::user_config_dir("rirods")
  create_config_dir(path_to_config_dir)
  file.path(path_to_config_dir, "conf.irods")
}

find_irods_file <- function(what) {

  check_irods_conf()
  # find iRODS configuration file
  irods_conf_file <- path_to_irods_conf()
  # read irods file
  x <- readLines(irods_conf_file)
  # find line
  x <- x[grepl(what, x)]
  # extract information
  sub(paste0(what, ": "), "", x)
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
  if (length(readLines(irods_conf_file)) < 2) {
    stop("iRODS configuration file is incomplete. Did you supply the correct ",
         "host and/or zone name with `create_irods()`?", call. = FALSE)
  }

  invisible(irods_conf_file)
}
