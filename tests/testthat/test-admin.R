with_mock_dir("admin", {
  test_that("compare shell with R solution", {

    auth()

    # curl in shell
    shell <- system(system.file(package = "rirods2", "bash", "iadmin.sh"))
    # curl in R
    R <- iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
    expect_equal(R, shell)

    # remove user bobby
    iadmin(action = "remove", target = "user", arg2 = "bobby")
  })
})
