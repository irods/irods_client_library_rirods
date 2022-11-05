# test_that("compare shell with R solution", {
#
#   # this can not be accommodated by httptest2
#   skip_if_offline()
#   skip_if(inherits(tk, "try-error"))
#
#   # curl in shell
#   shell <- system2(
#     system.file(package = "rirods", "bash", "iadmin.sh"),
#       c(user, pass, host, lpath),
#       "add",
#       "user",
#       "bobby",
#       "rodsuser"
#     ),
#     stdout = TRUE,
#     stderr = FALSE
#   ) |>
#     jsonlite::fromJSON()
#
#   # curl in R
#   iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
#   R <- ils(path = lpath)
#
#   # compare list output
#   expect_equal(R, shell$`_embedded`)
#
#   # remove user bobby
#   iadmin(action = "remove", target = "user", arg2 = "bobby")
# })
#
