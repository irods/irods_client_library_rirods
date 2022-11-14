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

# chunk file
chunk_file <- function(fil, count) {

  # chunk sizes
  size <- file.size(fil)
  x <- calc_chunk_size(size, count)

  # read compressed file
  con <- file(fil, "rb")
  on.exit(close(con))
  dat <- readBin(con, "raw", size)

  # chunk data
  rw <- split(dat, x[[1]])

  # file names
  bs <- basename(fil) |> tools::file_path_sans_ext()
  fm <- file.path(tempdir(), paste0(bs, 1:length(rw), ".rds"))

  # write to temo dir
  Map(function(x, y) writeBin(x, y), rw, fm)


  list(fm, x[[2]], x[[3]])
}

# fuse file after chunking (this will be a raw vector from irods)
fuse_file <- function(x) {
  Reduce(append, x)
}

# calculate chunk sizes
calc_chunk_size <- function (file_size, count) {
  # try to find the number of chunks
  n <- file_size %/% count
  st <- sort(1:file_size %% n)
  # count
  ct <- as.integer(table(st))
  # offset
  of <- c(0, cumsum(ct)[1:length(ct)-1])
  list(st, of, ct)
}
