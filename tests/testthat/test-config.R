test_that("assert_rfacts_paths()", {
  old <- Sys.getenv("RFACTS_PATHS")
  Sys.setenv(RFACTS_PATHS = "")
  on.exit(Sys.setenv(RFACTS_PATHS = old))
  expect_error(assert_rfacts_paths(), regexp = "RFACTS_PATHS")
})

test_that("missing column in paths df", {
  paths <- .rfacts$paths
  paths$facts_version <- NULL
  expect_error(assert_paths_df(paths), regexp = "required")
})

test_that("missing column in paths df", {
  skip_paths()
  paths <- .rfacts$paths
  paths$executable_type[1] <- "nope"
  expect_error(assert_paths_df(paths), regexp = "flfll")
})

test_that("rfacts_paths()", {
  skip_paths()
  expect_true(is.data.frame(rfacts_paths()))
  expect_silent(assert_paths_df(rfacts_paths()))
})

test_that("rfacts_sitrep()", {
  skip_paths()
  expect_true(is.data.frame(rfacts_sitrep()))
})

test_that("reset_rfacts_paths()", {
  skip_paths()
  expect_silent(reset_rfacts_paths())
  expect_true(is.data.frame(rfacts_paths()))
})
