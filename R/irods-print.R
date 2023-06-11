#' Print Method for iRODS Data Frame Class.
#'
#' @param x An object of class `irods_df`.
#' @inheritParams base::print.data.frame
#'
#' @seealso [print.data.frame()]
#' @return Invisibly return the class `irods_df` object.
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#'
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' # use_irods_demo()
#'
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authenticate
#' iauth("rods", "rods")
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store data in iRODS
#' isaveRDS(foo, "foo.rds")
#'
#' # add some metadata
#' imeta(
#'   "foo.rds",
#'   "data_object",
#'   operations =
#'    data.frame(operation = "add", attribute = "foo", value = "bar",
#'      units = "baz")
#' )
#'
#' # iRODS Zone with metadata
#' irods_zone <- ils(metadata = TRUE)
#'
#' # print (default no row.names)
#' print(irods_zone)
#'
#' # with row.names
#' print(irods_zone, row.names = TRUE)
#'
#' # delete object
#' irm("foo.rds", force = TRUE)
#'
#' # remove iRODS project file
#' unlink(paste0(basename(getwd()), ".irods"))
#'
print.irods_df <- function (x, ..., digits = NULL,
                            quote = FALSE, right = TRUE, row.names = FALSE,
                            max = NULL) {

    if (length(x$logical_path) == 0L) {
      cat("This collection does not contain any objects or collections.")
    } else {
      df <- extract_df(x, "metadata", ..., digits = digits, quote = quote,
                       right = right, row.names = row.names,
                       max = max)
      df <- extract_df(df, "status_information", ..., digits = digits,
                       quote = quote, right = right, row.names = row.names,
                       max = max)
      df <- extract_df(df, "permission_information", ..., digits = digits,
                       quote = quote, right = right, row.names = row.names,
                       max = max)
      cat(paste0(
        "\n",
        strrep("=", 10),
        "\n",
        "iRODS Zone",
        "\n",
        strrep("=", 10),
        "\n"
      ))
      print(as.data.frame(df),  ..., digits = digits,
            quote = quote, right = right, row.names = row.names,
            max = max)
      x
    }
    invisible(x)
}

extract_df <- function(df, var, ..., digits, quote, right, row.names, max) {
  if (!is.null(extract <- df[[var]] )) {
    remainder <- df[names(df) != var]
    if (methods::is(extract, "data.frame")) {
      df <- cbind(remainder, extract)
    } else if (methods::is(extract, "list")) {
      names(extract) <- df$logical_path
      print_extract(extract, var, ..., digits = digits,
                    quote = quote, right = right, row.names = row.names,
                    max = max)
      df <- remainder
    }
  }
  df
}

print_extract <- function(x, var, ..., digits, quote, right, row.names, max) {
  nn <- names(x)
  ll <- length(x)

  cat(paste0(
    "\n",
    strrep("=", nchar(var)),
    "\n",
    var,
    "\n",
    strrep("=", nchar(var)),
    "\n"
  ))
  for (i in seq_len(ll)) {
    cat(nn[i], ":\n")
    print(x[[i]],  ..., digits = digits,
          quote = quote, right = right, row.names = row.names,
          max = max)
    cat("\n")
  }
}
