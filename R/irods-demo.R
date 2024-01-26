#' Run Docker iRODS Demonstration Service
#'
#' Run an iRODS demonstration server with `use_irods_demo()` as a Docker
#' container instance. The function `stop_irods_demo()` stops the containers.
#'
#' These functions are untested on Windows and macOS and require:
#'  * `bash`
#'  * `docker`
#'
#' @param user Character vector for user name (defaults to "rods" admin)
#' @param pass Character vector for password (defaults to "rods" admin password)
#' @param recreate Boolean to indicate whether to recreate (reboot) the iRODS
#'  demo server (defaults to `FALSE`). Recreating will destroy all content on
#'  the current instance.
#' @param verbose Verbosity (defaults to `TRUE`).
#' @references
#'  https://github.com/irods/irods_demo
#'
#' @return Invisible
#' @export
#'
#' @examples
#'
#' if (interactive()) {
#'
#'   # launch docker irods_demo containers (and possibly download images) with
#'   # default credentials
#'   use_irods_demo()
#'
#'   # same but then with "alice" as user and "PASSword" as password
#'   use_irods_demo("alice", "PASSword")
#'
#'   # stop containers
#'   stop_irods_demo()
#' }
#'
use_irods_demo <- function(user = character(), pass = character(),
                           recreate = FALSE, verbose = TRUE) {

  # check if Docker is installed and can be accessed without sudo rights
  docker_version <- system("docker --version", ignore.stdout = !verbose,
                           ignore.stderr = !verbose)
  if (Sys.which("bash") == "" ||
      Sys.which("docker") == "" ||
      docker_version == "") {
    stop(
      "Bash and Docker are required. \n",
      "Install bash and docker to commence. Alternatively, sudo rights \n",
      "are required for Docker: please check: \n",
      "https://docs.docker.com/engine/install/linux-postinstall/",
      call. = FALSE
    )
  }

  # do irods_demo images exist on this machine?
  irods_images <- system2(
    system.file(package = "rirods", "shell_scripts", "docker-images.sh"),
    stdout = TRUE,
    stderr = FALSE
  )

  resp_user <- TRUE
  if (length(irods_images) == 0 ||
      !all(grepl(paste0(irods_images_ref, collapse = "|"), irods_images))
      ) {
    message("\nThe iRODS demo Docker containers are not built on this system. \n")
    if (interactive()) {
      resp_user <-
        utils::askYesNo("Would you like it to be built?", default = FALSE)
    }
  }

  # launch irods_demo
  if (isTRUE(resp_user)) {
    start_irods(verbose, recreate)
  } else {
    stop("The iRODS server could not be started!", call. = FALSE)
  }

  if (length(user) != 0 && length(pass) != 0) {
    system2(
      system.file(package = "rirods", "shell_scripts", "iadmin-docker-icommand.sh"),
      c(user, pass),
      stdout = FALSE,
      stderr = FALSE
    )
  } else {
    user <- pass <- "rods"
  }

  # Sometimes it just does not want to start right. This will perform a dry run
  # and restart the process again. This usually does the trick.
  dry_run_irods(user, pass, recreate)

  if (isTRUE(verbose)) {
    message(
      "\n",
      "Do the following to connect with the iRODS demo server: \n",
      "create_irods(\"http://localhost:9001/irods-http-api/0.1.0\") \n",
      "iauth(\"", user, "\", \"", pass, "\")"
    )
  }

  invisible(NULL)
}
#' @rdname use_irods_demo
#'
#' @export
stop_irods_demo <- function() {
  system(paste0("cd ", path_to_demo(), " ; docker compose down"))
  invisible()
}

#' Predicate for iRODS Demonstration Service State
#'
#' A predicate to check whether you are running iRODS docker demo containers.
#'
#' @param ... Currently not implemented.
#' @return Boolean whether or not connected to iRODS
#' @export
#'
#' @examples
#' is_irods_demo_running()
is_irods_demo_running <- function(...) {

  # check for client-icommand is not required (only needed for demo itself)
  irods_container_ref <- paste0(irods_images_ref, "-1")
  irods_container_ref[6] <- "irods_demo-irods-client-http-api-1" # inconsistent naming between image and container
  irods_container_ref <-
    irods_container_ref[irods_container_ref != "irods_demo-irods-client-icommands-1"]
  is_irods_demo_running_ <- function(x) {
    system2(
      system.file(package = "rirods", "shell_scripts", "docker-containers.sh"),
      x,
      stderr = NULL
    )
  }
  irods_containers_state <-
    vapply(
      irods_container_ref,
      is_irods_demo_running_,
      integer(1)
    )

  if (sum(irods_containers_state) == 0) TRUE else FALSE
}

#' Remove Docker images from system
#' @keywords internal
#' @return Invisible
remove_docker_images <- function() {
  if (is_irods_demo_running()) {
    stop("Docker containers are still running. Stop them with ",
         "`stop_irods_demo()` and proceed", call. = FALSE)
  }
  bsh <-
    system.file(package = "rirods", "shell_scripts", "docker-images-remove.sh")
  Map(
    function(x) {
      system(paste("docker rmi", x), ignore.stderr = TRUE)
    },
    irods_images_ref
  )
  invisible()
}

start_irods <- function(verbose, recreate = TRUE) {
  if (isTRUE(recreate)) {
    cmd <- " ; docker compose up -d --force-recreate nginx-reverse-proxy irods-client-http-api irods-client-icommands"
  } else {
    cmd <- " ; docker compose up -d nginx-reverse-proxy irods-client-http-api irods-client-icommands"
  }
  system(
    paste0("cd ", path_to_demo(), cmd),
    ignore.stdout = !verbose,
    ignore.stderr = !verbose
  )
}

path_to_demo <- function() system.file("irods_demo", package = "rirods")

# perform dry run to see if iRODS can be used
dry_run_irods <- function(user, pass, recreate) {
  tryCatch(
    {local_create_irods(); iauth(user, pass); ils()},
    error = function(err)  {
      if (isFALSE(recreate)) {
        message(
          "\nThere seems to be a problem with the iRODS demo ",
          "server. \nThe problem might be solved by rebooting the server. ",
          "\nThis action will destroy all content on the server!\n"
        )
        recreate <- utils::askYesNo("Can I reboot the server?", default = FALSE)
      }

      if (isTRUE(recreate)) {
        message("\nThis may take a while!\n")
        start_irods(recreate)
        use_irods_demo(user, pass, recreate, verbose = FALSE)
      } else {
        stop("The iRODS server could not be started!", call. = FALSE)
      }
    }
  )
}

# look up table for irods_demo images
irods_images_ref <- c(
  "irods_demo-irods-catalog",
  "irods_demo-irods-catalog-provider",
  "irods_demo-irods-client-icommands",
  "irods_demo-irods-client-rest-cpp",
  "irods_demo-nginx-reverse-proxy",
  "irods/irods_http_api"
)

#' Launch iRODS from Alternative Directory
#'
#' This function is useful during development as it prevents cluttering of the
#' package source files.
#'
#' @param host Hostname of the iRODS server. Defaults to
#'  ""http://localhost:9001/irods-http-api/0.1.0".
#' @param dir The directory to use. Default is a temporary directory.
#' @param env Attach exit handlers to this environment. Defaults to the
#'  parent frame (accessed through [parent.frame()]).
#'
#' @return Invisibly returns the original directory.
#' @keywords internal
#'
local_create_irods <- function(
  host = NULL,
  dir = tempdir(),
  env = parent.frame()
) {

  # default host
  if (is.null(host)) {
    if (Sys.getenv("DEV_KEY_IROD") != "") {
      host <-
        httr2::secret_decrypt(Sys.getenv("DEV_HOST_IRODS"), "DEV_KEY_IRODS")
    } else {
      host <- "http://localhost:9001/irods-http-api/0.1.0"
    }
  }

  # to return to
  old_dir <- getwd()

  # change working directory
  setwd(dir)
  withr::defer(setwd(old_dir), envir = env)

  # switch to new iRODS project
  create_irods(host, overwrite = TRUE)
  withr::defer(unlink(path_to_irods_conf()), envir = env)

  invisible(dir)
}
