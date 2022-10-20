# try({
#   # switch to new irods project
#   create_irods("http://localhost/irods-rest/0.9.2", overwrite = TRUE)
#
#   # authenticate
#   iauth()
#
#   # add user bobby
#   iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
#
#   # modify pass word bobby
#   iadmin(action = "modify", target = "user", arg2 = "bobby", arg3 = "password", arg4  = "passWORD")
# },
# silent = TRUE
#
# )
