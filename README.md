
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rirods2

<!-- badges: start -->
<!-- badges: end -->

The goal of rirods2 is a pure R client for iRODS

## Installation

You can install the development version of rirods2 like so:

``` r
# install.packages("devtools")
devtools::install_github("MartinSchobben/rirods2")
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

Then to connect a project from R with the iRODS server you have to
provide the host name of the server, like so:

``` r
library(rirods2)

# connect project to server
create_irods("http://localhost/irods-rest/0.9.2")
```

In this example Bobby is a user of iRODS and he can authenticate
himself, like so:

``` r
# login as bobby
iauth("bobby", "passWORD")
```

Suppose Bobby would like to upload an R object from his current R
session to an iRODS collection. For this, use the iput command:

``` r
# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# check where we are
ipwd()
#> [1] "/tempZone/home/bobby"

# store
iput(foo)

# add some metadata
imeta(
  "foo", 
  "data_object", 
  operations = 
    list(operation = "add", attribute = "foo", value = "bar", units = "baz")
)

# check if file is stored with associated metadata
ils(metadata = TRUE)
#>               logical_path      metadata        type
#> 1 /tempZone/home/bobby/foo foo, bar, baz data_object
```

If Bobby wanted to copy the foo R object from an iRODS collection to his
local directory, he would use iget:

``` r
# retrieve in native R format
iget("foo")
#>   x y
#> 1 1 x
#> 2 8 y
#> 3 9 z

# delete object
irm("foo", trash = FALSE)

# check if object is removed
ils()
#> This collection does not contain any objects or collections.
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
#> 1 /tempZone/home/bobby/foo.csv data_object
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

# delete object
irm("foo.csv", trash = FALSE)
```

<!-- The user Bobby can also be removed again. -->

## Stop your local iRODS server

``` bash
docker-compose down
```
