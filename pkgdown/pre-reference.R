MANPATH <- system.file("man", package="rirods")
replace_sexpr <- function(man_file) {
  man_file <- file.path(MANPATH, man_file)
  sexpr_sub <- gsub(
    "\\\\Sexpr.*",
    deparse(substitute(create_irods(x, overwrite = TRUE), list(x = rirods:::.irods_host))),
    readLines(man_file)
  )

  writeLines(sexpr_sub, man_file)
}

Map(replace_sexpr, list.files(MANPATH, pattern = ".Rd"))
