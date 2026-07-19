# Coerce to a Data Frame

Coerce iRODS Zone information class to
[`data.frame()`](https://rdrr.io/r/base/data.frame.html).

## Usage

``` r
# S3 method for class 'irods_df'
as.data.frame(x, ...)
```

## Arguments

- x:

  `irods_df` class object.

- ...:

  Currently not implemented

## Value

Returns a `data.frame`. Note, that the columns of metadata consists of a
list of data frames, and status_information and permission_information
consist of data frames.

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

# check class
class(irods_zone)

# coerce into `data.frame` and extract metadata of "foo.rds"
irods_zone <- as.data.frame(irods_zone)
irods_zone[basename(irods_zone$logical_path) == "foo.rds", "metadata"]

# delete object
irm("foo.rds", force = TRUE)
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
