#' Title
#'
#' @param x object, collection or user
#' @param entity_type Type (object, collection or user)
#' @param operations List which contains the following named elements;
#'  `operation`, which adds (`"add"`) or removes (`"remove"`) the object, and
#'   the metadata triplet attribute, value, units.
#' @param path Path to object (defaults to `"."`).
#' @param verbose Show information about the http request and response.
#'
#' @return Invisibly returns the response.
#' @export
#'
#' @examples
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
    lpath <- paste0(.rirods2$current_dir, "/", x)
  } else {
    lpath <- paste0(path, "/", x)
  }

  # check list depth if 1 add another layer
  if (list_depth(operations) == 1) operations <- list(operations)

  # data to be converted to json for body (double operation list important for boxing)
  json <- list(
    entity_name = lpath,
    entity_type = entity_type,
    operations = operations
    )

  resp <- irods_rest_call("metadata", "POST", args = list(), verbose, json)

  invisible(resp)
}

# cmds generator
gen_cmds <- function(x, entity_type, operation, attribute, value, units) {

  op <- gen_cmds_(operation, attribute, value, units)
  paste0(
    '{',
      '"entity_name": "', x, '",',
      '"entity_type": "', entity_type, '",',
      '"operations": [',
        op,
      ']',
    '}'
  )
}

gen_cmds_ <- function(operation, attribute, value, units) {
  paste0(
    '{',
      '"operation": "', operation, '",',
      '"attribute": "', attribute, '",',
      '"value": "', value, '",',
      '"units": "', units, '"',
    '}'
  )
}

# measure depth of list (https://stackoverflow.com/questions/13432863/determine-level-of-nesting-in-r)
list_depth <- function(this, thisdepth = 0) {
  if(!is.list(this)) {
    thisdepth
  } else {
    max(unlist(lapply(this, list_depth, thisdepth = thisdepth + 1)))
  }
}
