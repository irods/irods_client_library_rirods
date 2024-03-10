with_mock_dir("print-1", {
  test_that("output is printed 1", {
    # no content
    expect_message(print(ils()),
                   "This collection does not contain any objects or collections.")
  })
},
simplify = FALSE)

with_mock_dir("print-2", {
  test_that("output is printed 2", {
    # object 1
    bar <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
    isaveRDS(bar, "bar.rds", overwrite = T)

    # object 2
    qux <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
    isaveRDS(qux, "qux.rds", overwrite = T)

    # stat
    expect_equal(ncol(as.data.frame(ils(stat = TRUE))), 11L)
    expect_equal(nrow(as.data.frame(ils(stat = TRUE))), 2L)

    # metadata
    test_imeta(paste0(irods_test_path, "/qux.rds"),
               operations =
                 list(
                   list(
                     operation = "add",
                     attribute = "foo",
                     value = "bar",
                     units = "baz"
                   )
                 ))


    ref <- structure(
      list(
        logical_path = paste0(irods_test_path, c("/bar.rds", "/qux.rds")),
        attribute = c(NA_character_, "foo"),
        value = c(NA_character_, "bar"),
        units = c(NA_character_, "baz")
      ),
      row.names = 1:2,
      class = "irods_df"
    )

    expect_output(print.irods_df(ils(metadata = TRUE)),
                  paste0(capture.output(print(ref)), collapse = "\n"))
    test_irm(paste0(irods_test_path, "/qux.rds"))
    test_irm(paste0(irods_test_path, "/bar.rds"))
  })
},
simplify = FALSE)
