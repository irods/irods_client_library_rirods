# Authentication Service for an iRODS Zone

Provides an authentication service for an iRODS zone. Using the function
without arguments results in a prompt asking for the user name and
password thereby preventing hard-coding of sensitive information in
scripts.

## Usage

``` r
iauth(user, password = NULL, role = "rodsuser")
```

## Arguments

- user:

  iRODS user name (prompts user for user name if not supplied).

- password:

  iRODS password (prompts user for password if not supplied).

- role:

  iRODS role of user (defaults to `"rodsuser"`).

## Value

Invisibly `NULL`.

## Examples

``` r
if (FALSE) { # is_irods_demo_running()
is_irods_demo_running()

# demonstration server (requires Bash, Docker and Docker-compose)
# use_irods_demo()
DONTSHOW({
.old_config_dir <- Sys.getenv("R_USER_CONFIG_DIR")
Sys.setenv("R_USER_CONFIG_DIR" = tempdir())
})
# connect project to server
create_irods("http://localhost:9001/irods-http-api/0.2.0", overwrite = TRUE)

# authenticate
iauth("rods", "rods")
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
