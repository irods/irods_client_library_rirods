#' Save Files and Objects in iRODS
#'
#' Store an object or file into iRODS. [iput()] should be used to transfer
#' a file from the local storage to iRODS; [isaveRDS()] saves an R object from
#' the current environment in iRODS in RDS format (see [saveRDS()]).
#'
#' @param local_path Local path of file to be sent to iRODS.
#' @param x R object to save in iRODS.
#' @param logical_path Destination path in iRODS.
#' @param offset Offset in bytes into the data object. Deprecated.
#' @param count Maximum number of bytes to write. Deprecated.
#' @param truncate Whether to truncate the object when opening it. Deprecated.
#' @param verbose Whether to print information about the HTTP request and
#'  response. Defaults to `FALSE`.
#' @param overwrite Whether the file in iRODS should be overwritten if it
#'  exists. Defaults to `FALSE`.
#' @param ticket A valid iRODS ticket string. Defaults to `NULL`.
#'
#' @return (Invisibly) the HTTP response.
#' @seealso
#'  [iget()] for obtaining files,
#'  [ireadRDS()] for obtaining R objects from iRODS,
#'  [readRDS()] for an R equivalent.
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#' \dontshow{
#' .old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
#' .old_wd <- setwd(tempdir())
#' Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
#' }
#' # connect project to server
#' \Sexpr[stage=build, results=rd]{paste0("create_irods(\"", rirods:::.irods_host, "\")")}
#'
#' # authenticate
#' iauth("rods", "rods")
#'
#' # save the iris dataset as csv and send the file to iRODS
#' write.csv(iris, "iris.csv")
#' iput("iris.csv", "iris.csv")
#'
#' # save with a different name
#' iput("iris.csv", "iris_in_irods.csv")
#' ils()
#'
#' # send an R object to iRODS in RDS format
#' isaveRDS(iris, "iris_in_rds.rds")
#'
#' # delete objects in iRODS
#' irm("iris_in_irods.csv", force = TRUE)
#' irm("iris_in_rds.rds", force = TRUE)
#' irm("iris.csv", force = TRUE)
#'
#' \dontshow{
#' setwd(.old_wd)
#' Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
#' }
iput <- function(
    local_path,
    logical_path,
    offset = 0,
    count = 0,
    truncate = TRUE,
    verbose = FALSE,
    overwrite = FALSE,
    ticket = NULL
  ) {

  # deprecate arguments
  if (!missing("offset"))
    warning("Argument `offset` is deprecated")
  if (!missing("count"))
    warning("Argument `count` is deprecated")

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path, write = TRUE)

  # check if iRODS object already exists and whether it should be overwritten
  stop_irods_overwrite(overwrite, logical_path)

  # check if local file exists
  if (!(is.character(local_path) && file.exists(local_path))) {
    stop("Local file [", basename(local_path) , "] does not exist.",
         call. = FALSE)
  }

  # handle file to iRODS conversion
  reqs <-  local_to_irods(
    object = local_path,
    logical_path = logical_path,
    count =  find_irods_file("max_size_of_request_body_in_bytes"),
    ticket = ticket,
    verbose = verbose
  )

  # check if transfer is chunked
  if (inherits(reqs, "httr2_request")) {
    resps <- httr2::req_perform(reqs)
  } else {
    resps <- sequential_parallel_perform(
      reqs,
      logical_path = logical_path,
      ticket = ticket,
      verbose = verbose
    )
  }
  invisible(resps)
}

#' @rdname iput
#' @export
isaveRDS <- function(
    x,
    logical_path,
    offset = 0,
    count = 0,
    truncate = TRUE,
    verbose = FALSE,
    overwrite = FALSE,
    ticket = NULL
) {

  # deprecate arguments
  if (!missing("offset"))
    warning("Argument `offset` is deprecated")
  if (!missing("count"))
    warning("Argument `count` is deprecated")

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path, write = TRUE)

  # check if iRODS object already exists and whether it should be overwritten
  stop_irods_overwrite(overwrite, logical_path)

  # object name
  name <- deparse(substitute(x))

  # check if the R object exists in the calling environment
  if (!exists(name, envir = parent.frame())) {
    stop("Local object [", name ,"] does not exist.", call. = FALSE)
  }

  # handle R object to iRODS conversion
  reqs <- local_to_irods(
    object = x,
    logical_path = logical_path,
    count = find_irods_file("max_size_of_request_body_in_bytes"),
    ticket = ticket,
    verbose = verbose
  )

  # check if transfer is chunked
  if (inherits(reqs, "httr2_request")) {
    resps <- httr2::req_perform(reqs)
  } else {
    resps <- sequential_parallel_perform(
      reqs,
      logical_path = logical_path,
      ticket = ticket,
      verbose = verbose
    )
  }

  invisible(resps)
}

sequential_parallel_perform <- function(
    reqs,
    logical_path,
    truncate = 1,
    append = 0,
    ticket,
    verbose
  ) {

  list_truncate <- rep(0, length(reqs))
  list_append <- rep(0, length(reqs))
  list_truncate[1] <- truncate
  list_append[1] <- append

  Map(function(x, truncate, append) {
    parallel_perform(
      reqs = x,
      logical_path = logical_path,
      truncate = truncate,
      append = append,
      ticket = ticket,
      verbose = verbose
    )
  },
  reqs,
  list_truncate,
  list_append
  )
}

parallel_perform <- function(
    reqs,
    logical_path,
    truncate,
    append,
    ticket,
    verbose
  ) {
  max_number_of_parallel_write_streams <- find_irods_file("max_number_of_parallel_write_streams")
  parallel_write_handle <-
    parallel_write_init(
      logical_path = logical_path,
      stream_count = max_number_of_parallel_write_streams,
      truncate = truncate,
      append = append,
      ticket = ticket,
      verbose = verbose
    )
  add_parallel_write_handle <- function(req) {
    httr2::req_body_multipart(req, `parallel-write-handle` = parallel_write_handle)
  }
  reqs <- Map(add_parallel_write_handle, reqs)
  resps <- httr2::req_perform_parallel(reqs)
  parallel_write_shutdown(parallel_write_handle, verbose = verbose)
  resps
}

local_to_irods <- function(
    object,
    logical_path,
    count,
    ticket,
    verbose
  ) {

  if (is.character(object) && file.exists(object)) {
    # make a connection to read the file as raw bytes
    object_size <- file.size(object)
    object <- file(object, "rb", raw = TRUE)
    on.exit(close(object))
  } else {
    object <- serialize(object, connection = NULL)
    object_size <- length(object)
  }

  # vectorised call of file which enables chunked object transfer in case of
  # larger object size than `count` bytes
  if (object_size > count) {
    max_number_of_parallel_write_streams <- find_irods_file("max_number_of_parallel_write_streams")
    list_of_chunks <- calc_chunk_size(object_size, count, max_number_of_parallel_write_streams)
    chunked_local_to_irods(
      list_of_chunks = list_of_chunks,
      logical_path = logical_path,
      truncate = 1,
      append = 0,
      ticket = ticket,
      verbose = verbose,
      object = object
    )
  } else {
    local_to_irods_(
      object = object,
      logical_path = logical_path,
      offset = 0,
      count = object_size,
      truncate = 1,
      append = 0,
      verbose = verbose,
      stream_index = NULL
    )
  }
}

# calculate chunk sizes
calc_chunk_size <- function(x, count, max_number_of_parallel_write_streams) {
  # stop if object size is less than count
  if (x < count)
    stop("Object size smaller than count.", call. = FALSE)
  # check that object size exceeds with more than 2 times the size
  if (x %/% count == 1) {
    # otherwise take half the count
    count <- count / 2
  }
  # try to find the number of chunks
  n <- x %/% count
  st <- sort(1:x %% n)
  # count
  ct <- as.integer(table(st))
  # offset
  of <- c(0, cumsum(ct)[1:length(ct) - 1])
  si <- rep(seq(1, max_number_of_parallel_write_streams), length.out = length(ct))
  ci <- sort(rep(seq(1, ceiling(length(ct) / max_number_of_parallel_write_streams)), length.out = length(ct)))
  Map(list, of, ct, si) |> split(ci)
}

chunked_local_to_irods <- function(
    list_of_chunks,
    object,
    logical_path,
    truncate,
    append,
    ticket,
    verbose
  ) {

  list_truncate <- rep(0, length(list_of_chunks))
  list_append <- rep(0, length(list_of_chunks))
  list_truncate[1] <- truncate
  list_append[1] <- append

  Map(function(chunks, truncate, append) {
    chunked_local_to_irods_(
      chunks = chunks,
      object = object,
      logical_path = logical_path,
      truncate = truncate,
      append = append,
      verbose = verbose
    )
  },
  list_of_chunks,
  list_truncate,
  list_append
  )
}

#' Chunked object to iRODS conversion
#' @noRd
chunked_local_to_irods_ <- function(
    chunks,
    object,
    logical_path,
    truncate,
    append,
    verbose
  ) {
  Map(function(x) {
    local_to_irods_(
      object = object,
      logical_path = logical_path,
      offset = x[[1]],
      count =  x[[2]],
      truncate = truncate,
      append = append,
      verbose = verbose,
      stream_index =  x[[3]]
    )
  },
  chunks
  )
}
#' Object to iRODS conversion
#' @noRd
local_to_irods_ <- function(
    object,
    logical_path,
    offset,
    count,
    truncate,
    append,
    stream_index,
    ticket,
    verbose
  ) {

  # if connection then only here read the data chunk
  if (inherits(object, "connection")) {
    object <- readBin(object, raw(), n = count, endian = "swap")
  } else if (inherits(object, "raw")) {
    object <- object[(offset + 1):(offset + count + 1)] # R specific index
  }

  # flags to curl call
  args <- list(
    op = "write",
    lpath = logical_path,
    offset = offset,
    truncate = truncate,
    append = append,
    bytes = curl::form_data(object, type = "application/octet-stream"),
    `stream-index` = stream_index
  )

  # http call
  irods_http_call("data-objects", "POST", args, verbose)
}

parallel_write_init <- function(
    logical_path,
    stream_count,
    truncate,
    append,
    ticket,
    verbose
) {

  # flags to curl call
  args <- list(
    op = "parallel_write_init",
    lpath = logical_path,
    `stream-count` = stream_count,
    truncate = truncate,
    append = append
  )

  # http call
  resp <- irods_http_call("data-objects", "POST", args, verbose) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  resp$parallel_write_handle
}

parallel_write_shutdown <- function(parallel_write_handle, verbose) {

  # flags to curl call
  args <- list(
    op = "parallel_write_shutdown",
    `parallel-write-handle` = parallel_write_handle
  )

  # http call
  resp <- irods_http_call("data-objects", "POST", args, verbose) |>
    httr2::req_perform()

  invisible(resp)
}
#' Retrieve File or Object from iRODS
#'
#' Transfer a file from iRODS to the local storage with [iget()] or
#' read an R object from an RDS file in iRODS with [ireadRDS()]
#' (see [readRDS()]).
#'
#' @param logical_path Source path in iRODS.
#' @param local_path Destination path in local storage.
#' @param offset Offset in bytes into the data object. Deprecated.
#' @param count Maximum number of bytes to write. Deprecated.
#' @param verbose Whether information should be printed about the HTTP request
#'  and response. Defaults to `FALSE`.
#' @param overwrite Whether the local file should be overwritten if it exists.
#'    Defaults to `FALSE`.
#' @param ticket A valid iRODS ticket string. Defaults to `NULL`.
#'
#' @return The R object in case of `ireadRDS()`, invisibly `NULL` in case of
#'  `iget()`.
#' @seealso
#'  [iput()] for sending files,
#'  [isaveRDS()] for sending R objects to iRODS,
#'  [saveRDS()] for an R equivalent.
#'
#' Transfer a file from iRODS to the local storage with `iget()` or
#' read an R object from an RDS file in iRODS with `ireadRDS()` (see `readRDS()`).
#'
#' @param logical_path Source path in iRODS.
#' @param local_path Destination path in local storage. By default,
#'   the basename of the logical path; the file will be stored in the current
#'   directory (see `getwd()`).
#' @param offset Offset in bytes into the data object. Deprecated.
#' @param count Maximum number of bytes to write. Deprecated.
#' @param verbose Whether information should be printed about the HTTP request and response.
#' @param overwrite Whether the local file should be overwritten if it exists.
#'    Defaults to `FALSE`.
#'
#' @return The R object in case of `ireadRDS()`, invisibly `NULL` in case of `iget()`.
#' @export
#'
#' @examplesIf is_irods_demo_running()
#' is_irods_demo_running()
#' \dontshow{
#' .old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
#' .old_wd <- setwd(tempdir())
#' Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
#' }
#' # connect project to server
#' \Sexpr[stage=build, results=rd]{paste0("create_irods(\"", rirods:::.irods_host, "\")")}
#'
#' # authenticate
#' iauth("rods", "rods")
#'
#' # save the iris dataset as csv and send the file to iRODS
#' write.csv(iris, "iris.csv")
#' iput("iris.csv", "iris.csv")
#'
#' # bring the file back with a different name
#' iget("iris.csv", "newer_iris.csv")
#' file.exists("newer_iris.csv") # check that it has been transferred
#'
#' # send an R object to iRODS in RDS format
#' isaveRDS(iris, "irids_in_rds.rds")
#'
#' # read it back
#' iris_again <- ireadRDS("irids_in_rds.rds")
#' iris_again
#'
#' # delete objects in iRODS
#' irm("irids_in_rds.rds", force = TRUE)
#' irm("iris.csv", force = TRUE)
#'
#' \dontshow{
#' setwd(.old_wd)
#' Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
#' }
iget <- function(
    logical_path,
    local_path,
    offset = 0,
    count = 0,
    verbose = FALSE,
    overwrite = FALSE,
    ticket = NULL
  ) {

  # deprecate arguments
  if (!missing("offset"))
    warning("Argument `offset` is deprecated")
  if (!missing("count"))
    warning("Argument `count` is deprecated")

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # check for local file
  stop_local_overwrite(overwrite, local_path)

  # write to file
  if (file.exists(local_path))
    unlink(local_path)
  # handle iRODS to local file conversion
  req <- irods_to_local(
    logical_path = logical_path,
    ticket = ticket,
    verbose = verbose
  )

  resp <- httr2::req_perform(req, path = local_path)
  # return
  invisible(resp)
}

#' @rdname iget
#'
#' @export
ireadRDS <- function(
    logical_path,
    offset = 0,
    count = 0,
    verbose = FALSE,
    ticket = NULL
) {

  # deprecate arguments
  if (!missing("offset"))
    warning("Argument `offset` is deprecated")
  if (!missing("count"))
    warning("Argument `count` is deprecated")

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # handle iRODS to R object conversion
  req <- irods_to_local(
    logical_path = logical_path,
    ticket = ticket,
    verbose = verbose
  )

  con <- httr2::req_perform(req) |>
    httr2::resp_body_raw()

  unserialize(con)
}

irods_to_local <- function(logical_path, ticket, verbose) {

  # flags to curl call
  args <- list(op = "read", lpath = logical_path, ticket = ticket)

  # http call
  irods_http_call("data-objects", "GET", args, verbose)
}
