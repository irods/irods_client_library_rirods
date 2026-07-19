# Print Method for iRODS Data Frame Class.

Print Method for iRODS Data Frame Class.

## Usage

``` r
# S3 method for class 'irods_df'
print(
  x,
  ...,
  digits = NULL,
  quote = FALSE,
  right = TRUE,
  row.names = FALSE,
  max = NULL,
  message = TRUE
)
```

## Arguments

- x:

  An object of class `irods_df`.

- ...:

  optional arguments to `print` methods.

- digits:

  the minimum number of significant digits to be used: see
  [`print.default`](https://rdrr.io/r/base/print.default.html).

- quote:

  logical, indicating whether or not entries should be printed with
  surrounding quotes.

- right:

  logical, indicating whether or not strings should be right-aligned.
  The default is right-alignment.

- row.names:

  logical (or character vector), indicating whether (or what) row names
  should be printed.

- max:

  numeric or `NULL`, specifying the maximal number of entries to be
  printed. By default, when `NULL`,
  [`getOption`](https://rdrr.io/r/base/options.html)`("max.print")`
  used.

- message:

  Show message when empty collection. Default to `TRUE`.

## Value

Invisibly return the class `irods_df` object.

## See also

[`print.data.frame()`](https://rdrr.io/r/base/print.dataframe.html)

## Examples

``` r
if (FALSE) { # is_irods_demo_running()
is_irods_demo_running()
DONTSHOW({
.old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
})
# connect project to server
create_irods("http://localhost:9001/irods-http-api/0.2.0", overwrite = TRUE)

# authenticate
iauth("rods", "rods")

# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# store data in iRODS
isaveRDS(foo, "foo.rds")

# add some metadata
imeta(
  "foo.rds",
  operations =
   data.frame(operation = "add", attribute = "foo", value = "bar",
     units = "baz")
)

# iRODS Zone with metadata
irods_zone <- ils(metadata = TRUE)

# print (default no row.names)
print(irods_zone)

# with row.names
print(irods_zone, row.names = TRUE)

# delete object
irm("foo.rds", force = TRUE)
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
