maximum_number_of_rows_catalog <- function(user_input) {
  limit <- find_irods_file("max_number_of_rows_per_catalog_query")
  if (user_input < limit) {
    limit <- user_input
  }
  limit
}

limit_maximum_number_of_rows_catalog <- function(irods_zone, limit) {
  if (!inherits(irods_zone, c("data.frame", "list")))
    stop("The supplied irods_zone is not of class data.frame or list")
  if (nrow(as.data.frame(irods_zone)) > limit) {
    irods_zone <- as.data.frame(irods_zone)[1:limit, , drop = FALSE]
  }
  irods_zone
}
