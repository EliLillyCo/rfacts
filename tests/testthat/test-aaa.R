test_that("FLFLL/engine paths exist", {
  skip_paths()
  db_engines <- paths_engine()
  db_flflls <- paths_flfll()
  expect_true(length(db_engines$path) > 0L)
  expect_true(length(db_flflls$path) > 0L)
  all(file.exists(db_flflls$path))
  all(file.exists(db_engines$path))
})

test_that("%||%", {
  expect_equal("x" %||% "y", "x")
  expect_equal(NULL %||% "y", "y")
  expect_equal(NA_character_ %||% "y", NA_character_)
})

test_that("%||NA%", {
  expect_equal("x" %||NA% "y", "x")
  expect_equal(NULL %||NA% "y", "y")
  expect_equal(NA_character_ %||NA% "y", "y")
})

test_that("choose_version()", {
  expect_equal(choose_version("4.1", c("4.1", "5.1", "6.1")), "4.1")
  expect_equal(choose_version("5.1", c("4.1", "5.1", "6.1")), "5.1")
  expect_equal(choose_version("6.1", c("4.1", "5.1", "6.1")), "6.1")
  expect_equal(choose_version("5.1", c("4.1", "5.1", "6.1")), "5.1")
  expect_equal(choose_version("5.1.1", c("4.1", "5.1", "6.1")), "5.1")
  expect_equal(choose_version("5.0.1", c("4.1", "5.1", "6.1")), "4.1")
  expect_equal(choose_version("99999", c("4.1", "5.1", "6.1")), "6.1")
  expect_equal(choose_version("3", c("4.1", "5.1", "6.1")), "4.1")
})

test_that("warn0()", {
  expect_warning(warn0("xyz"), regexp = "xyz")
})

test_that("stop0()", {
  expect_error(stop0("xyz"), regexp = "xyz")
})
