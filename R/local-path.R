# stop overwriting
stop_local_overwrite <- function(overwrite, x) {
  if (isFALSE(overwrite) && file.exists(x)) {
    stop(
      "Local file aready exists.",
      " Set `overwrite = TRUE` to explicitly overwrite the file.",
      call. = FALSE
    )
  }
}
