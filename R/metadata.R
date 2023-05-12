#' Add or remove metadata
#'
#' In iRODS, metadata is stored as attribute-value-units triples (AVUs), consisting
#' of an attribute name, an attribute value and an optional unit.
#' This function allows to chain several operations ('add' or 'remove') linked to
#' specific AVUs.
#'
#' @param logical_path Path to the data object or collection (or name of the user).
#' @param entity_type Type of item to add metadata to or remove it from.
#'   Options are 'data_object', 'collection' and 'user'.
#' @param operations List of named lists of vectors representing operations.
#'   The valid components of each of these lists or vectors are:
#'   - `operation`, with values 'add' or 'remove', depending on whether the AVU
#'  should be added to or removed from the metadata of the item.
#'   - `attribute`, with the name of the AVU.
#'   - `value`, with the value of the AVU.
#'   - `units`, with the unit of the AVU.
#' @param verbose Whether information should be printed about the HTTP request and response.
#'
#' @return Invisibly, the HTTP response.
#' @export
#'
#' @examples
#' if(interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authentication
#' iauth()
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store
#' iput(foo, "foo.rds")
#'
#' # check if file is stored
#' ils()
#'
#' # add some metadata
#' imeta(
#'  "foo.rds",
#'  "data_object",
#'  operations = list(
#'     operation = "add",
#'     attribute = "foo",
#'     value = "bar",
#'     units = "baz"
#'     )
#' )
#'
#'imeta(
#'  "foo.rds",
#'  "data_object",
#'  operations = list(
#'    list(operation = "add", attribute = "foo2", value = "bar2"),
#'    list(operation = "add", attribute = "foo3", value = "bar3")
#'  )
#' )
#'
#' # check if file is stored with associated metadata
#' ils(metadata = TRUE)
#' }
imeta <- function(
    logical_path,
    entity_type = c("data_object", "collection", "user"),
    operations = list(),
    verbose = FALSE
) {

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path, open = "read")

  # define entity type
  entity_type <- match.arg(entity_type)

  # check list depth if 1 add another layer
  # TODO make a different check:
  # operations should ALWAYS be a list of lists
  # and those lists should have the right names inside.
  # list of list => also a dataframe should be allowed
  if (list_depth(operations) == 1)
    operations <- list(operations)

  # data to be converted to json for body (double operation list important for boxing)
  json <- list(
    entity_name = logical_path,
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

# TODO add some reference to documentation to how to query?
#' Query data objects and collections in iRODS
#'
#' Use SQL-like expressions to query data objects and collections based on different properties.
#'
#' @param query GeneralQuery for searching the iCAT database.
#' @param limit Maximum number of rows to return. Defaults to 100.
#' @param offset Number of rows to skip for paging. Defaults to 0.
#' @param type Type of query: 'general' (the default) or 'specific'.
#' @param case_sensitive Whether the string matching in the query is case sensitive.
#'   Defaults to `TRUE`.
#' @param distinct Whether only distinct rows should be listed. Defaults to `TRUE`.
#' @param verbose Whether information should be printed about the HTTP request and response.
#'
#' @return Invisibly, the HTTP response.
#' @export
#'
#' @examples
#' if(interactive()) {
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authentication
#' iauth()
#'
#' # search for objects by metadata
#' iquery("SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '/tempZone/home/%'")
#' iquery("SELECT COLL_NAME, DATA_NAME WHERE META_DATA_ATTR_NAME LIKE 'foo%'")
#' }
iquery <- function(
    query,
    limit = 100,
    offset = 0,
    type = c('general', 'specific'),
    case_sensitive = TRUE,
    distinct = TRUE,
    verbose = FALSE
  ) {
  type <- match.arg(type)

  # flags to curl call
  args <- list(
    limit = limit,
    offset = offset,
    type = type,
    `case-sensitive` = as.integer(case_sensitive),
    distinct = as.integer(distinct),
    query = query
  )

  # http call
  resp <- irods_rest_call("query", "GET", args, verbose)

  # response
  out <- httr2::resp_body_json(
    resp,
    check_type = FALSE,
    simplifyVector = TRUE
  )$`_embedded`

  out
}
