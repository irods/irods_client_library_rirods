#' Retrieve an object from iRODS
#'
#' @param dir Change the current directory to DIR.  The default DIR is the value
#'  of the HOME shell variable.
#'
#' @return invisibly returns the path
#' @export
#'
#' @examples
#'
#' # authenticate
#' auth()
#'
#' # default dir
#' icd(".")
#' ils()
#'
#' # some other dir
#' icd("/tempZone/home")
#' ils()
#'
#' # go back on level lower
#' icd("..")
#' ils()
#'
#' # relative paths work as well
#' icd("home/public")
#' ils()
#'
icd  <- function(dir) {

  # get current dir
  if (dir  == ".") {
    current_dir <- local(current_dir, envir = .rirods2)
  }

  # get level lower
  if (dir  == "..") {
    current_dir <- local(current_dir, envir = .rirods2)
    current_dir <- sub(paste0("/", basename(current_dir)), "", current_dir)
    if (current_dir == character(1)) current_dir <- "/"
  }

  # get requested dir
  if (!dir %in% c(".", "..")) {

    if(grepl("^/", dir)) {
      current_dir <- dir
    } else {
      base_dir <- icd(".")
      current_dir <- paste0(base_dir, ifelse(base_dir == "/", "", "/"), dir)
    }

    # check if exist
    idir <- try(ils(path = current_dir), silent = TRUE)
    if (inherits(idir, "try-error")) stop("Dir does not exist.")

    current_dir
  }

  # store internally
  .rirods2$current_dir <- current_dir

  # return location
  invisible(current_dir)
}
