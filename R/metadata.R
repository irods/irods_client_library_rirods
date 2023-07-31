#' Add or Remove Metadata
#'
#' In iRODS, metadata is stored as attribute-value-units triples (AVUs), consisting
#' of an attribute name, an attribute value and an optional unit.
#' This function allows to chain several operations ('add' or 'remove') linked to
#' specific AVUs. Read more about metadata by looking at the iCommands
#' equivalent `imeta` in the [iRODS Docs](https://docs.irods.org/master/icommands/metadata/).
#'
#' @param logical_path Path to the data object or collection (or name of the user).
#' @param entity_type Type of item to add metadata to or remove it from.
#'   Options are 'data_object', 'collection' and 'user'.
#' @param operations List of named lists or [data.frame] representing operations.
#'   The valid components of each of these lists or vectors are:
#'   - `operation`, with values 'add' or 'remove', depending on whether the AVU
#'  should be added to or removed from the metadata of the item (required).
#'   - `attribute`, with the name of the AVU (required).
#'   - `value`, with the value of the AVU (required).
#'   - `units`, with the unit of the AVU (optional).
#' @param verbose Whether information should be printed about the HTTP request
#'  and response. Defaults to `FALSE`.
#'
#' @return Invisibly, the HTTP response.
#' @seealso [iquery()]
#'
#' @references
#' https://docs.irods.org/master/icommands/metadata/
#'
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
#' # authentication
#' iauth("rods", "rods")
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store
#' isaveRDS(foo, "foo.rds")
#'
#' # check if file is stored
#' ils()
#'
#' # add some metadata
#' imeta(
#'   "foo.rds",
#'   "data_object",
#'    operations =
#'     list(
#'      list(operation = "add", attribute = "foo", value = "bar", units = "baz")
#'    )
#' )
#'
#' # `operations` can contain multiple tags supplied as a `data.frame`
#' imeta(
#'   "foo.rds",
#'   "data_object",
#'   operations = data.frame(
#'     operation = c("add", "add"),
#'     attribute = c("foo2", "foo3"),
#'     value = c("bar2", "bar3"),
#'     units = c("baz2", "baz3")
#'    )
#'  )
#'
#' # or again as a list of lists
#' imeta(
#'   "foo.rds",
#'   "data_object",
#'   operations = list(
#'     list(operation = "add", attribute = "foo4", value = "bar4", units = "baz4"),
#'     list(operation = "add", attribute = "foo5", value = "bar5", units = "baz5")
#'   )
#' )
#'
#' # list of lists are useful as AVUs don't have to contain units
#' imeta(
#'   "foo.rds",
#'   "data_object",
#'   operations = list(
#'     list(operation = "add", attribute = "foo6", value = "bar6"),
#'     list(operation = "add", attribute = "foo7", value = "bar7", units = "baz7")
#'   )
#' )
#'
#' # check if file is stored with associated metadata
#' ils(metadata = TRUE)
#'
#' # delete object
#' irm("foo.rds", force = TRUE)
#'
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

    # check for class `dataframe` and turn into list of lists
  if (inherits(operations, "data.frame")) {
    operations <- apply(operations, 1, as.list)
  }

  # check for names of `list` of lists
  if (inherits(operations, "list")) {
    content_operations <- unlist(operations, recursive = FALSE)
    if (inherits(content_operations, "list")) {
      operations_names <- unique(names(content_operations))
      names_ref <- c("operation", "attribute", "value", "units")
      if (!all(operations_names %in% names_ref)) {
        names_msg <- paste0(paste0("\"", names_ref,  "\""), collapse = ", ")
        stop("The supplied `operations` should have names that can include ",
             names_msg, ".", call. = FALSE)
      } else {
        # check for operation to be one of "add" or "remove"
        operations_ <- vapply(operations, "[[", character(1), "operation")
        if (!all(operations_ %in% c("add", "remove"))) {
          stop("The element \"operation\" of `operations` can contain \"add\"",
               " or \"remove\".", call. = FALSE)
        }
      }
    } else if (!is.null(content_operations)) {
      stop("The supplied list of `operations` should contain a named `list`.",
           call. = FALSE)
    }
  } else {
    stop("The supplied `operations` should be of type `list` or `data.frame`.",
         call. = FALSE)
  }

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

#' Query Data Objects and Collections in iRODS
#'
#' Use SQL-like expressions to query data objects and collections based on
#' different properties. Read more about queries by looking at the iCommands
#' equivalent `iquest` in the [iRODS Docs](https://docs.irods.org/master/icommands/user/#iquest).
#'
#' @param query GeneralQuery for searching the iCAT database.
#' @param limit Maximum number of rows to return. Defaults to 100.
#' @param offset Number of rows to skip for paging. Defaults to 0.
#' @param type Type of query: 'general' (the default) or 'specific'.
#' @param case_sensitive Whether the string matching in the query is case
#'  sensitive. Defaults to `TRUE`.
#' @param distinct Whether only distinct rows should be listed. Defaults to
#'  `TRUE`.
#' @param verbose Whether information should be printed about the HTTP request
#'  and response. Defaults to `FALSE`.
#'
#' @return A dataframe with one row per result and one column per requested attribute,
#'   with "size" and "time" columns parsed to the right type.
#' @seealso [imeta()]
#'
#' @references
#'  https://docs.irods.org/master/icommands/user/#iquest
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
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#'
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' # use_irods_demo()
#'
#' # connect project to server
#' create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
#'
#' # authentication
#' iauth("rods", "rods")
#'
#' # some data
#' foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#' # store
#' isaveRDS(foo, "foo.rds")
#'
#' # add metadata
#' imeta(
#'   "foo.rds",
#'   "data_object",
#'   operations =
#'     list(
#'       list(operation = "add", attribute = "bar", value = "baz")
#'   )
#' )
#'
#' # search for objects by metadata
#' iquery("SELECT COLL_NAME, DATA_NAME WHERE META_DATA_ATTR_NAME LIKE 'bar%'")
#'
#' # delete object
#' irm("foo.rds", force = TRUE)
#'
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

  try(
    {
      column_names <- strsplit(
        gsub(
          "SELECT ([A-Z_, ]+)( WHERE .+)?",
          "\\1",
          toupper(query)
        ), ", "
      )[[1]]
      colnames(out) <- column_names
      out <- as.data.frame(out)

      for (col in column_names) {
        if (endsWith(col, "TIME")) {
          out[[col]] <- as.POSIXct(as.numeric(out[[col]]), origin = "1970-01-01")
        } else if (endsWith(col, "SIZE")) {
          out[[col]] <- as.numeric(out[[col]])
        }
      }

    },
    silent = TRUE
  )

  out
}
