test_that("comparer shell with R solution", {
  shell <- system(
    paste0("SECRETS=$(echo -n rods:rods | base64); TOKEN=$(curl -X POST -H",
           " 'Authorization: Basic ${SECRETS}'",
           "http://localhost:80/irods-rest/0.9.2/auth)"))
  R <- get_token()

})
