#' Run Docker iRODS demonstration service
#'
#' Run an iRODS demonstration server as an Docker container instance.
#' The functions `stop_irods_demo()` and `remove_docker_images()` are used to
#' stop the containers, and subsequently remove the images. Note that calling
#' `use_irods_demo()` consecutively will reset the server with a clean slate.
#'
#' These functions are untested on Windows and macOS and require:
#'  * `bash`
#'  * `docker`
#'  * `docker-compose`
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
#'   # default credentials.
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
      Sys.which("docker") == ""  ||
      docker_version == "" ||
      Sys.which("docker-compose") == "") {
    stop(
      "Bash and Docker with the docker-compose plugin are required. ",
      "Install bash and docker to commence. Alternatively, sudo rights ",
      "are required for Docker: please check: ",
      "https://docs.docker.com/engine/install/linux-postinstall/",
      call. = FALSE
    )
  }

  # does irods_demo exist
  irods_images <-
    system("docker image ls | grep irods_demo_",
           intern = TRUE,
           ignore.stderr = TRUE)
  irods_status <-
    try(attr(irods_images, "status") == 1, silent = TRUE)

  resp_user <- TRUE
  if (isTRUE(irods_status) ||
      !all(grepl(paste0(irods_images_ref, collapse = "|"), irods_images))) {
    resp_user <- utils::askYesNo(
      paste0(
        "The iRODS demo Docker containers are not build on this system.",
        "Would you like it to be build?"
      )
    )
  }

  # launch irods_demo
  if (isTRUE(resp_user)) {
    start_irods(verbose, recreate)
  }

  if (length(user) != 0 && length(pass) != 0) {
    system2(
      system.file(package = "rirods", "bash", "iadmin-docker-icommand.sh"),
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
      "create_irods(\"http://localhost/irods-rest/0.9.3\", \"tempZone/home\") \n",
      "iauth(\"", user, "\", \"", pass, "\")"
    )
  }

  invisible()
}
#' @rdname use_irods_demo
#'
#' @export
stop_irods_demo <- function() {
  system(paste0("cd ", path_to_demo(), " ; docker-compose down"))
  invisible()
}
#' @rdname use_irods_demo
#'
remove_docker_images <- function() {
  system("docker compose down", intern = TRUE)
  system("docker system prune --force", intern = TRUE)
  system(
    paste0("docker image rm ", irods_images_ref, collapse = " && "),
    intern = TRUE
  )
  invisible()
}

start_irods <- function(verbose, recreate = TRUE) {
  if (isTRUE(recreate)) {
    cmd <- " ; docker-compose up -d --force-recreate nginx-reverse-proxy"
  } else {
    cmd <- " ; docker-compose up -d nginx-reverse-proxy"
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
    {local_create_irods(); iauth(user, pass)},
    error = function(err)  {
      if (isFALSE(recreate)) {
        message(
          "\nThere seems to be a problem with the iRODS demo ",
          "server. \nThe problem might be solved by rebooting the server. ",
          "\nThis action will destroy all content on the server!\n"
        )
        recreate <- utils::askYesNo("Can I reboot the server?")
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

# check if containers are running
is_irods_demo_running <- function() {
  irods_container_ref <- paste0(irods_images_ref, "_1")
  cmd <- paste0(
    "docker container inspect -f '{{.State.Running}}' ",
    irods_container_ref,
    collapse = " ; "
  )
  is_up <-
    suppressWarnings(system(
      cmd,
      intern = TRUE,
      ignore.stderr = TRUE,
      ignore.stdout = TRUE
    ))
  status_irods <- attr(is_up, "status")
  if (is.null(status_irods))
    TRUE
  else
    FALSE
}

# look up table for irods_demo images
irods_images_ref <- c(
  "irods_demo_irods-catalog",
  "irods_demo_irods-catalog-provider",
  "irods_demo_irods-client-icommands",
  "irods_demo_irods-client-rest-cpp",
  "irods_demo_nginx-reverse-proxy"
)
