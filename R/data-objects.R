#' Working with iRODS data objects
#'
#' Store a file into iRODS with `iput()`. If the destination data-object or
#' collection are not provided, the current iRODS directory and the input file
#' name are used. Get data-objects or collections from iRODS space with `iget()`
#' , either to the specified local area or to the current working directory.
#'
#' @param x R object stored on iRODS server.
#' @param path Local path.
#' @param logical_path Destination path.
#' @param offset Offset in bytes into the data object (Defaults to FALSE).
#' @param truncate Truncates the object on open (defaults to TRUE).
#' @param count Maximum number of bytes to read or write.
#' @param verbose Show information about the http request and response.
#' @param overwrite Overwrite irods object or local file (defaults to FALSE).
#'
#' @return Invisibly the http response in case of `iput()`, or invisibly NULL
#' or an R object in case of `iget()`.
#'
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
#' # retrieve in native R format
#' iget("foo.rds")
#' }
iput <- function(
    x,
    logical_path,
    offset = 0,
    count = 3000L,
    truncate = "true",
    verbose = FALSE,
    overwrite = FALSE
  ) {

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # check if irods object already exists and whether it should be overwritten
  stop_irods_overwrite(overwrite, logical_path)

  # what type of object are we dealing with
  if (is.character(x) && file.exists(x)) {
    fil <- x
  } else if (is.symbol(substitute(x))) {
    # object name
    name <- deparse(substitute(x))
    # # make intermediate file
    fil <- tempfile(name, fileext = ".rds")
    # serialize and gz compress
    saveRDS(x, fil)
  } else {
    stop("Local object or file does not exist.", call. = FALSE)
  }

  # when object is larger then cut object in pieces
  if (file.size(fil) > count) {
    #---------------------------------------------------------------------------
    # this is a hack to make it work
    pl <- tempfile("place_holder", fileext = paste0(".", tools::file_ext(fil)))
    saveRDS("place_holder", pl)
    # flags to curl call
    args <- list(
      `logical-path` = logical_path,
      offset = offset,
      count = count
    )
    irods_rest_call("stream", "PUT", args, verbose, pl)
    truncate <- "false"
    #---------------------------------------------------------------------------
    x <- chunk_file(fil, count)
  } else {
    x <- list(fil, offset = 0, count)
  }

  # vectorised call of file which enables chunked file transfer in case of larger
  # file size than `count` bytes
  Map(
    function(x, y, z) {
      iput_(
        x = x,
        offset = y,
        count = z,
        logical_path = logical_path,
        truncate = truncate,
        verbose = verbose
      )
    },
    x[[1]],
    x[[2]],
    x[[3]]
  )

  invisible(NULL)
}
# internal
iput_ <- function(x, offset, count, logical_path, truncate, verbose) {

  # flags to curl call
  args <- list(
    `logical-path` = logical_path,
    offset = offset,
    count = count,
    truncate = truncate
  )

  # http call
  out <- irods_rest_call("stream", "PUT", args, verbose, x)

  # response
  invisible(out)
}
#' @rdname iput
#'
#' @export
iget <- function(
    logical_path,
    path = ".",
    offset = 0,
    count = 3000L,
    verbose = FALSE,
    overwrite = FALSE
  ) {

  # local path
  path <- file.path(path, basename(logical_path))

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # file size on irods
  file_size <- ils(logical_path, stat = TRUE)[[2]][[2]]

  # when object is larger then cut object in pieces
  if (file_size  > count) {
    # chunk size
    chunk_size <- calc_chunk_size(file_size, count)
    # vectorised call
    resp <- Map(function(offset, count) {
      iget_(
        logical_path = logical_path,
        offset = offset,
        count = count,
        verbose = verbose
      )
    },
    chunk_size[[2]],
    chunk_size[[3]])
    # fuse files
    resp <- fuse_file(resp)
  } else {
    resp <-
      iget_(
        logical_path = logical_path,
        offset = offset,
        count = count,
        verbose = verbose
      )
  }

  # convert to file or R object
  if (is.character(logical_path) && tools::file_ext(logical_path) != "rds") {
    # check for local file/ R object
    stop_local_overwrite(overwrite, path)
    # close connection
    on.exit(close(con))
    # write file
    con <- file(path, "wb")
    writeBin(resp, con)
    invisible(NULL)
  } else {
    # close connection
    on.exit(close(con))
    # create R object
    con <- rawConnection(resp)
    readRDS(gzcon(con))
  }
}
# internal
iget_ <- function(logical_path, offset, count, verbose) {

  # flags to curl call
  args <- list(`logical-path` = logical_path, offset = offset, count = count)

  # http call
  out <- irods_rest_call("stream", "GET", args, verbose)

  # parse response
  httr2::resp_body_raw(out)
}
