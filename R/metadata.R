#' Describe your iRODS objects
#'
#' Metadata attribute-value-units triples (AVUs) consist of an Attribute-Name,
#' Attribute-Value, and an optional Attribute-Units. They can be added
#' via the 'add' command ,or removed with 'remove', and then queried to find
#' matching objects.
#'
#' @param logical_path object, collection or user
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
#' @param case_sensitive Affects string matching (defaults to TRUE).
#' @param distinct Only list distinct rows (defaults to TRUE).
#'
#' @return Invisibly returns the response.
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
    logical_path,
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

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path, open = "read")

  # check list depth if 1 add another layer
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

#' @rdname imeta
#'
#' @export
iquery <- function(
    query,
    limit = 100,
    offset = 0,
    type = 'general',
    case_sensitive = TRUE,
    distinct = TRUE,
    verbose = FALSE
  ) {

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
