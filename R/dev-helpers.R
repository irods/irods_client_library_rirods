#' Remove http snapshots or mockfiles
#' @keywords internal
#' @return Invisibly the mock file paths.
#'
remove_mock_files <- function() {
  # find the mock dirs
  pt <- file.path(getwd(), testthat::test_path())
  fls <- list.files(pt, include.dirs = TRUE)
  mockers <- fls[!grepl(pattern = "((.*)\\..*$)|(^_)",  x= fls)]
  # remove mock dirs
  unlink(file.path(pt, mockers), recursive = TRUE)
  invisible(file.path(pt, mockers))
}

