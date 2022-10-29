#' Describe your data
#'
#' @param x object, collection or user
#' @param entity_type Type (object, collection or user)
#' @param operations List which contains the following named elements;
#'  `operation`, which adds (`"add"`) or removes (`"remove"`) the object, and
#'   the metadata triplet attribute, value, units.
#' @param path Path to object (defaults to `"."`).
#' @param verbose Show information about the http request and response.
#'     query
#' @param query GeneralQuery for searching the iCAT database.
#' @param limit  The max number of rows to return (defaults to 100)
#' @param offset Number of rows to skip for paging (defaults to 0).
#' @param type Either 'general' or 'specific' (defaults to 'general').
#' @param casesensitive Affects string matching (defaults to TRUE).
#' @param distinct Only list distinct rows (defaults to TRUE).
#'
#' @return Invisibly returns the response.
#' @export
#'
#' @examples
#' if(interactive()) {
#' # authentication
#' iauth()
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store
#' iput(foo)
#'
#' # check if file is stored
#' ils()
#'
#' # add some metadata
#'# add some metadata
#' imeta(
#'  "foo",
#'  "data_object",
#'  operations =
#'   list(operation = "add", attribute = "foo", value = "bar", units = "baz")
#' )
#'
#' # check if file is stored with associated metadata
#' ils(metadata = TRUE)
#'
#' # search for objects by metadata
#' iquery("SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '/tempZone/home/%'")
#' }
imeta <- function(
    x,
    entity_type,
    operations =
      list(
        operation = "add",
        attribute = NULL,
        value = NULL,
        units = NULL
      ),
    path = ".",
    verbose = FALSE
) {

  # logical path
  if (path == ".") {
    lpath <- paste0(.rirods$current_dir, "/", x)
  } else {
    lpath <- paste0(path, "/", x)
  }

  # check list depth if 1 add another layer
  if (list_depth(operations) == 1)
    operations <- list(operations)

  # data to be converted to json for body (double operation list important for boxing)
  json <- list(
    entity_name = lpath,
    entity_type = entity_type,
    operations = operations
    )

  # http call
  resp <- irods_rest_call("metadata", "POST", args = list(), verbose, json)

  invisible(resp)
}

# measure depth of list (https://stackoverflow.com/questions/13432863/determine-level-of-nesting-in-r)
list_depth <- function(this, thisdepth = 0) {
  if(!is.list(this)) {
    thisdepth
  } else {
    max(unlist(lapply(this, list_depth, thisdepth = thisdepth + 1)))
  }
}

#' @rdname imeta
#'
#' @export
iquery <- function(
    query,
    limit = 100,
    offset = 0,
    type = 'general',
    casesensitive = TRUE,
    distinct = TRUE,
    verbose = FALSE
  ) {

  # flags to curl call
  args <- list(
    limit = limit,
    offset = offset,
    type = type,
    `case-sensitive` = as.integer(casesensitive),
    distinct = as.integer(distinct),
    query = query
  )

  # http call
  resp <- irods_rest_call("query", "GET", args, verbose)

  out <- httr2::resp_body_json(
    resp,
    check_type = FALSE,
    simplifyVector = TRUE
  )$`_embedded` |>
    as.data.frame()

  if (nrow(out) > 0 ) colnames(out) <- c("collection", "data_object")
  out
}
