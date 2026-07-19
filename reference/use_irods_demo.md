# Run Docker iRODS Demonstration Service

Run an iRODS demonstration server with `use_irods_demo()` as a Docker
container instance. The function `stop_irods_demo()` stops the
containers.

## Usage

``` r
use_irods_demo(
  user = character(),
  pass = character(),
  recreate = FALSE,
  verbose = TRUE
)

stop_irods_demo(verbose = TRUE)
```

## Arguments

- user:

  Character vector for user name (defaults to "rods" admin)

- pass:

  Character vector for password (defaults to "rods" admin password)

- recreate:

  Boolean to indicate whether to recreate (reboot) the iRODS demo server
  (defaults to `FALSE`). Recreating will destroy all content on the
  current instance.

- verbose:

  Verbosity (defaults to `TRUE`).

## Value

Invisible

## Details

These functions are untested on Windows and macOS and require:

- `bash`

- `docker`

## References

https://github.com/irods/irods_demo

## Examples

``` r

if (interactive()) {

  # launch docker irods_demo containers (and possibly download images) with
  # default credentials
  use_irods_demo()

  # same but then with "alice" as user and "PASSword" as password
  use_irods_demo("alice", "PASSword")

  # stop containers
  stop_irods_demo()
}
```
