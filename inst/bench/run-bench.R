#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
out_file_name <- args[[1]]
out_file_path <- args[[2]]
rirods_source <- args[[3]]
rirods_version <- args[[4]]
num <- args[[5]]

# run in temp dir
tmp_dir <- tempdir()
setwd(tmp_dir)
print(getwd())

# project
if (!(requireNamespace("renv", quietly = TRUE) && requireNamespace("usethis", quietly = TRUE)))
  install.packages(c("renv", "usethis"))
usethis::create_project(".")

# isolate library
renv::init(bare = TRUE)

# install dependencies
install.packages(c("remotes", "bench", "readr", "knitr", "here", "dplyr",
                   "ggplot2", "readr", "tidyr"))

# install rirods
if (startsWith(rirods_source, "/")) {
  remotes::install_local(rirods_source)
  rirods_source <- "/local/path"
} else {
  remotes::install_github(
    paste0("https://github.com/", rirods_source),
    ref = rirods_version,
    force = TRUE
  )
}

# load for prettier expression labals
library("rirods")

# irods project in temp dir
rirods::create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home")
rirods::iauth("rods", "rods")

# range
rng <- 1:num
# different sizes
Map(
  function(x) readr::write_csv(data.frame(1:(1*10^(1 + x))), paste0("x", x, ".csv")),
  rng
)

timer_files <- function(file_name) {

  file_name <- paste0("x", file_name, ".csv")
  for_comparison <- readr::read_csv(file_name, show_col_types = FALSE)

  # time execution
  time_iput <- bench::mark(
    iput(file_name, overwrite = TRUE, count = 1000),
    max_iterations = 100,
    filter_gc = FALSE
  )

  # memory used
  time_iput$mem_alloc <- bench::as_bench_bytes(time_iput$mem_alloc)
  time_iput$src <- rirods_source
  time_iput$ref <- rirods_version
  time_iput$size <- file.size(file_name)

  # time execution
  time_iget <- bench::mark(
    iget(file_name, overwrite = TRUE, count = 1000),
    max_iterations = 100,
    filter_gc = FALSE
  )

  # check whether input is same as output
  new_file <- readr::read_csv(file_name, show_col_types = FALSE)
  stopifnot(
    "Files are not the same after downloading from iRODS." = all.equal(for_comparison, new_file)
  )

  # memory used
  time_iget$mem_alloc <- bench::as_bench_bytes(time_iget$mem_alloc)
  time_iget$src <- rirods_source
  time_iget$ref <- rirods_version
  time_iget$size <- file.size(file_name)
  rbind(time_iget, time_iput)
}

# map over different file sizes with iput and iget commands
timer_sizes1 <- Map(timer_files, rng)

# clean-up
Map(function(x) {irm(paste0("x", x, ".csv"))}, rng)

#output log
readr::write_tsv(
  Reduce(rbind, timer_sizes1),
  file.path(out_file_path, paste0(out_file_name, "-files.tsv"))
)

timer_objects <- function(object_num) {

  object <- data.frame(1:(1*10^(1 + object_num)))

  # time execution
  time_isaveRDS <- bench::mark(
    isaveRDS(object, "object.rds", overwrite = TRUE, count = 1000),
    max_iterations = 100,
    filter_gc = FALSE
  )

  # memory used
  time_isaveRDS$mem_alloc <- bench::as_bench_bytes(time_isaveRDS$mem_alloc)
  time_isaveRDS$src <- rirods_source
  time_isaveRDS$ref <- rirods_version
  time_isaveRDS$size <- object.size(object)

  # time execution
  time_ireadRDS <- bench::mark(
    ireadRDS("object.rds", count = 1000),
    max_iterations = 100,
    filter_gc = FALSE
  )

  # check whether input is same as output
  new_object <- time_ireadRDS$result[[1]]
  stopifnot(
    "Objects are not the same after downloading from iRODS." = all.equal(object, new_object)
  )

  # memory used
  time_ireadRDS$mem_alloc <- bench::as_bench_bytes(time_ireadRDS$mem_alloc)
  time_ireadRDS$src <- rirods_source
  time_ireadRDS$ref <- rirods_version
  time_ireadRDS$size <- object.size(object)
  rbind(time_isaveRDS, time_ireadRDS)
}

# map over different object sizes with isaveRDS and ireadRDS commands
timer_sizes2 <- Map(timer_objects, rng)

# clean-up
irm("object.rds")

# output log
readr::write_tsv(
  Reduce(rbind, timer_sizes2),
  file.path(out_file_path, paste0(out_file_name, "-objects.tsv"))
)
