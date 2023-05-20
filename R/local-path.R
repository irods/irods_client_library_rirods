# stop overwriting
stop_local_overwrite <- function(overwrite, x) {
  if (isFALSE(overwrite)) {
    if (file.exists(x)) {
      stop(
        "Local file aready exists.",
        " Set `overwrite = TRUE` to explicitly overwrite the file.",
        call. = FALSE
      )
    }
  }
}

# chunk object (this needs to be a raw vector -> use serialize(x, NULL) for R
# object and readBIN for other file types)
chunk_object <- function(object, count) {

  # chunk sizes
  size <- length(object)
  x <- calc_chunk_size(size, count)

  # chunk data
  object_splits <- split(object, x[[1]])

  list(object_splits, x[[2]], x[[3]])
}

# chunk file
chunk_file <- function(file, count) {

  # chunk sizes
  size <- file.size(file)
  x <- calc_chunk_size(size, count)

  list(NULL, x[[2]], x[[3]])
}

# fuse object after chunking (this will be a raw vector from irods)
fuse_object <- function(x) {
  Reduce(append, x)
}

# calculate chunk sizes
calc_chunk_size <- function(x, count) {
  # stop if object size is less than  count
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
  list(object = st, offset = of, count = ct)
}
