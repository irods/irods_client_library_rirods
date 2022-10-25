
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rirods

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/MartinSchobben/rirods/branch/master/graph/badge.svg)](https://app.codecov.io/gh/MartinSchobben/rirods?branch=master)
[![R-CMD-check](https://github.com/MartinSchobben/rirods/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/MartinSchobben/rirods/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The rirods package is an R client for iRODS.

## Installation

You can install the development version of rirods like so:

``` r
# install.packages("devtools")
devtools::install_github("MartinSchobben/rirods")
```

## Example

This is a basic example which shows you how to quickly launch a local
iRODS server, connect with R, and perform some actions. For more
information on the iRODS demo server check
<https://github.com/irods/irods_demo>.

``` bash
# clone the repo
# git clone https://github.com/irods/irods_demo
# initiate git submodules
# git submodule update --init
# to start
cd ../irods_demo
docker-compose up
```

Provide the host name of the server to connect an R project with an
iRODS server, like so:

``` r
library(rirods)

# connect project to server
create_irods("http://localhost/irods-rest/0.9.2")
```

In this example Bobby is a user of iRODS and he can authenticate himself
with `iauth()`. This prompts a dialog where you can enter your username
and password without hardcoding this information in your scripts.

``` r
# login as bobby with password "passWORD"
iauth() # or iauth("bobby", "passWORD")
```

Suppose Bobby would like to upload an R object from his current R
session to an iRODS collection. For this, use the `iput()` command:

``` r
# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# check where we are
ipwd()
#> [1] "/tempZone/home/bobby"

# store
iput(foo)
```

To truly appreciate the strength of iRODS, we can add some metadata that
describes the data object “foo”.

``` r
# add some metadata
imeta(
  "foo", 
  "data_object", 
  operations = 
    list(operation = "add", attribute = "foo", value = "bar", units = "baz")
)

# check if file is stored with associated metadata
ils(metadata = TRUE)
#>                logical_path      metadata        type
#> 1  /tempZone/home/bobby/foo foo, baz, bar data_object
#> 2 /tempZone/home/bobby/test          NULL data_object
```

If Bobby wanted to copy the foo R object from an iRODS collection to his
local directory, he would use `iget()`:

``` r
# retrieve in native R format
iget("foo")
#>   x y
#> 1 1 x
#> 2 8 y
#> 3 9 z
```

Possibly Bobby does not want a native R object to be stored on iRODS but
a file type that can be accessed by other programs.

``` r
library(readr)

# creates a csv file of foo
write_csv(foo, "foo.csv")

# send file
iput("foo.csv")

# check whether it is stored
ils()
#>                   logical_path        type
#> 1     /tempZone/home/bobby/foo data_object
#> 2 /tempZone/home/bobby/foo.csv data_object
#> 3    /tempZone/home/bobby/test data_object
```

Later on somebody else might want to download this file again and store
it locally.

``` r
# retrieve it again later
iget("foo.csv")
read_csv("foo.csv")
#> Rows: 3 Columns: 2
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (1): y
#> dbl (1): x
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> # A tibble: 3 × 2
#>       x y    
#>   <dbl> <chr>
#> 1     1 x    
#> 2     8 y    
#> 3     9 z
```

By adding metadata you and others can more easily discover data in
future projects. Objects can be searched with General Queries and
`iquery()`:

``` r
# look for objects in the home directory with a wildcard `%`
iquery("SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME LIKE '/tempZone/home/%'")
#>             collection data_object
#> 1 /tempZone/home/bobby         foo
#> 2 /tempZone/home/bobby     foo.csv
#> 3 /tempZone/home/bobby        test
```

``` r
# or where data objects named "foo" can be found
iquery("SELECT COLL_NAME, DATA_NAME WHERE DATA_NAME LIKE 'foo%'")
#>                    collection        data_object
#> 1        /tempZone/home/bobby                foo
#> 2        /tempZone/home/bobby            foo.csv
#> 3  /tempZone/trash/home/bobby                foo
#> 4  /tempZone/trash/home/bobby     foo.1576729182
#> 5  /tempZone/trash/home/bobby     foo.2405108537
#> 6  /tempZone/trash/home/bobby     foo.2435297455
#> 7  /tempZone/trash/home/bobby     foo.2560339278
#> 8  /tempZone/trash/home/bobby      foo.826411162
#> 9  /tempZone/trash/home/bobby            foo.csv
#> 10 /tempZone/trash/home/bobby foo.csv.1036575935
#> 11 /tempZone/trash/home/bobby foo.csv.1144265542
#> 12 /tempZone/trash/home/bobby foo.csv.2236717404
#> 13 /tempZone/trash/home/bobby foo.csv.3876715845
#> 14 /tempZone/trash/home/bobby foo.csv.4082161960
```

Finally, we can clean up Bobby’s home directory:

``` r
# delete object
irm("foo", trash = FALSE)
irm("foo.csv", trash = FALSE)

# check if object is removed
ils()
#>                logical_path        type
#> 1 /tempZone/home/bobby/test data_object
```

<!-- The user Bobby can also be removed again. -->
