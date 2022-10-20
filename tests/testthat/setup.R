library(httptest2)

# fool the tests if no token is available (offline mode)
tk <- try(get_token(paste("rods", "rods", sep = ":")), silent = TRUE)
if (inherits(tk, "try-error")) {
  # store token
  assign("token", "secret", envir = .rirods2)
}

