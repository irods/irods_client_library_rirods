test_that("compare shell with R solution", {

  # currently mocking does not work
  skip_if(.rirods$token == "secret", "IRODS server unavailable")

  # only works on demo server
  skip_if(Sys.getenv("DEV_KEY_IRODS") != "", "Only for demo server.")

  # curl in shell
  shell <- system2(
    system.file(package = "rirods", "shell_scripts", "iadmin.sh"),
      c(user, pass, host, lpath, "add", "user", "bobby", "rodsuser"),
    stdout = TRUE,
    stderr = FALSE
  ) |>
    jsonlite::fromJSON()

  # remove user first
  iadmin(action = "remove", target = "user", arg2 = "bobby")
  # curl in R
  iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
  R <- ils(logical_path = lpath)

  # compare list output
  expect_equal(R, rirods:::new_irods_df(shell$`_embedded`))

  # remove user bobby
  iadmin(action = "remove", target = "user", arg2 = "bobby")
})

