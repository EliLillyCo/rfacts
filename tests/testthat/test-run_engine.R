test_that("run_engine_impl.default()", {
  expect_error(run_engine_impl.default(1, 2), "unsupported")
})

test_that("run_engine() with contin engine", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_flfll(facts_file, verbose = FALSE)
  run_engine(facts_file, param_files = out, n_sims = 1L, verbose = FALSE)
  files <- list.files(out, pattern = "patients[0-9]+\\.csv$", recursive = TRUE)
  expect_equal(length(files), 4L)
})

test_that("run_engine() with version", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_flfll(facts_file, verbose = FALSE)
  expect_error(
    run_engine(
      facts_file,
      param_files = out,
      n_sims = 1L,
      verbose = FALSE,
      version = "6.0.0.1"
    ),
    regexp = "multiple actual arguments"
  )
})
