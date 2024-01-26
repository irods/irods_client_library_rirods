#' Print Method for iRODS Data Frame Class.
#'
#' @param x An object of class `irods_df`.
#' @param message Show message when empty collection. Default to `TRUE`.
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
#' create_irods("http://localhost:9001/irods-http-api/0.1.0")
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
print.irods_df <- function (x, ..., digits = NULL,
                            quote = FALSE, right = TRUE, row.names = FALSE,
                            max = NULL, message = TRUE) {

    if (length(x$logical_path) == 0L && isTRUE(message)) {
      message("This collection does not contain any objects or collections.")
      invisible(x)
    } else {
      cat(paste0(
        "\n",
        strrep("=", 10),
        "\n",
        "iRODS Zone",
        "\n",
        strrep("=", 10),
        "\n"
      ))
      x <- as.data.frame(x)
      x[
        duplicated(x[[1]]) ,
        !colnames(x) %in% c("attribute", "value", "unit")
      ] <- character(1)
      print(x, ..., digits = digits,
            quote = quote, right = right, row.names = row.names,
            max = max)
      invisible(x)
    }
}
