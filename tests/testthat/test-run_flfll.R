test_that("informative error on old FACTS files", {
  skip_paths()
  facts_file <- get_facts_file_example("old.facts")
  expect_error(
    run_flfll(facts_file),
    regexp = "version of your FACTS file"
  )
})

test_that("run_flfll() does not share most arg names with engines", {
  flfll <- names(formals(run_flfll))
  x <- intersect(flfll, names(formals(run_engine_contin)))
  expect_equal(x, "verbose")
})

test_that("run_flfll() on broken.facts", {
  skip_paths()
  facts_file <- get_facts_file_example("broken.facts")
  expect_error(
    run_flfll(facts_file = facts_file, verbose = FALSE),
    regexp = "failed with exit code"
  )
})

test_that("run_flfll() on contin.facts with default args", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_flfll(facts_file = facts_file, verbose = FALSE)
  param_files <- get_param_files(out)
  expect_equal(length(param_files), 4L)
  expect_true(all(file.exists(param_files)))
  expect_true(all(grepl("nuk1_e\\.param", param_files)))
})

test_that("run_flfll() on contin.facts with more args", {
  skip_paths()
  out <- run_flfll(
    facts_file = get_facts_file_example("contin.facts"),
    output_path = tempfile(),
    log_path = tempfile(),
    n_burn = 4,
    n_mcmc = 4,
    n_weeks_files = 4,
    n_patients_files = 4,
    n_mcmc_files = 4,
    n_mcmc_thin = 2,
    flfll_seed = 1,
    flfll_offset = 1,
    verbose = FALSE
  )
  param_files <- get_param_files(out)
  expect_equal(length(param_files), 4L)
  expect_true(all(file.exists(param_files)))
  expect_true(all(grepl("nuk1_e\\.param", param_files)))
})
