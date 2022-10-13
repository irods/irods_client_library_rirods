
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
iRODS server. For more information check
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

To connect with the iRODS server on can do the following:

``` r
library(rirods2)
#> Start iRODS session.

# authenticate
auth()
```

In order to add a new user named Bobby one can do the following

``` r
# add user bobby
iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")

# modify pass word bobby
iadmin(action = "modify", target = "user", arg2 = "bobby", arg3 = "password", arg4  = "passWORD")

# check if bobby is added
icd("/tempZone/home")
ils()
#>            logical_path       type
#> 1  /tempZone/home/bobby collection
#> 2 /tempZone/home/public collection
#> 3   /tempZone/home/rods collection
```

## Data object management

Suppose Bobby would like to upload an R ocject from a current R session
to an iRODS collection. For this, use the iput command:

``` r
# some data
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

# set working directory to rods
icd("/tempZone/home/rods")

# check where we are
ipwd()
#> [1] "/tempZone/home/rods"

# store
iput(data = foo)

# check if file is stored
ils()
#>              logical_path        type
#> 1 /tempZone/home/rods/foo data_object
```

If Bobby wanted to copy the foo R object from an iRODS collection to his
local directory, he would use iget:

``` r
# retrieve in native R format
iget(data = "foo")
#>   x y
#> 1 1 x
#> 2 8 y
#> 3 9 z

# delete object
irm(data = "foo", trash = FALSE)

# check if file is delete
ils()
#> This collection does not contain any objects or collections.
```

The user Bobby can also be removed again.

``` r
# remove user bobby
iadmin(action = "remove", target = "user", arg2 = "bobby")

# check if bobby is removed
icd("/tempZone/home")
ils()
#>            logical_path       type
#> 1 /tempZone/home/public collection
#> 2   /tempZone/home/rods collection
```

## Stop your local iRODS server

``` bash
docker-compose down
```
