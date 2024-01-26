# test_that("user can be found", {
#   expect_error(iadmin("rods", action = "create_user", role = "rodsuser"))
#   expect_true(check_user_exists("rods"))
# })

# test_that("user can be added", {
#
#   alice_exists <- try(check_user_exists("Alice"), silent = TRUE)
#
#   skip_if(inherits(alice_exists, "try-error") || isTRUE(alice_exists))
#
#   expect_false(check_user_exists("Alice"))
#   expect_invisible(iadmin("Alice", action = "create_user", role = "rodsuser"))
#   expect_equal(list_users_irods_zone(), c("rods", "Alice"))
#   expect_invisible(iadmin("Alice", "pass", action = "set_password",  role = "rodsuser"))
#   expect_invisible(iadmin("Alice", action = "remove_user", role = "rodsuser"))
# })
