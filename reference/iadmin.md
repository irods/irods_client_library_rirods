# The Administration Interface to iRODS

Note that this function can only be used with admin rights.

## Usage

``` r
iadmin(
  name,
  password = character(1),
  action = c("create_user", "set_password", "remove_user"),
  role = c("rodsuser", "groupadmin", "rodsadmin"),
  verbose = FALSE
)
```

## Arguments

- name:

  Name of user to be added.

- password:

  Password to be added.

- action:

  The action: `"create_user"`, `"remove_user"`, or `"set_password"`.

- role:

  Role of user: `"rodsuser"`, `"groupadmin"`, and `"groupadmin"`.

- verbose:

  Show information about the http request and response. Defaults to
  `FALSE`.

## Value

Invisible http status.

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

# authentication
iauth("rods", "rods")

# add user
iadmin("Alice", action = "create_user", role = "rodsuser")

# add user password
iadmin("Alice", "pass", action = "set_password",  role = "rodsuser")

# delete user
iadmin("Alice", action = "remove_user", role = "rodsuser")
DONTSHOW({
Sys.setenv("R_USER_CONFIG_DIR" = .old_config_dir)
})
}
```
