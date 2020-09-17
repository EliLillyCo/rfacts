test_that("run_engine_contin() with default args", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_flfll(facts_file, verbose = FALSE)
  run_engine_contin(out, n_sims = 1L, verbose = FALSE)
  files <- list.files(out, pattern = "patients[0-9]+\\.csv$", recursive = TRUE)
  expect_equal(length(files), 4L)
})

test_that("run_engine_contin() on actual param files", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_flfll(facts_file, verbose = FALSE)
  param_files <- get_param_files(out)
  run_engine_contin(param_files[1], n_sims = 1L, verbose = FALSE)
  pattern <- "patients[0-9]+\\.csv$"
  files <- list.files(out, pattern = pattern, recursive = TRUE)
  expect_equal(length(files), 1L)
  run_engine_contin(param_files, n_sims = 1L, verbose = FALSE)
  files <- list.files(out, pattern = pattern, recursive = TRUE)
  expect_equal(length(files), 4L)
})

test_that("run_engine_contin() on actual param files in param file dir", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_flfll(facts_file, verbose = FALSE)
  param_files <- get_param_files(out)
  param_file <- basename(param_files[1])
  param_dir <- dirname(param_files[1])
  skip_if_not_installed("withr")
  withr::with_dir(
    param_dir,
    run_engine_contin(param_file, n_sims = 1L, verbose = FALSE)
  )
  pattern <- "patients[0-9]+\\.csv$"
  files <- list.files(out, pattern = pattern, recursive = TRUE)
  expect_equal(length(files), 1L)
})

test_that("run_engine_contin() with lots of sims", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  n_weeks <- 975
  n_subj <- 283
  n_mcmc <- 112
  out <- run_flfll(
    facts_file,
    n_burn = 5,
    n_mcmc = 5,
    n_weeks_files = n_weeks,
    n_patients_files = n_subj,
    n_mcmc_files = n_mcmc,
    flfll_seed = 1,
    verbose = FALSE
  )
  run_engine_contin(out, n_sims = 1e3, verbose = FALSE)
  files <- list.files(out, pattern = "weeks[0-9]+\\.csv$", recursive = TRUE)
  expect_equal(length(files), 4 * n_weeks)
  pattern <- "patients[0-9]+\\.csv$"
  files <- list.files(out, pattern = pattern, recursive = TRUE)
  expect_equal(length(files), 4 * n_subj)
  files <- list.files(out, pattern = "mcmc[0-9]+\\.csv$", recursive = TRUE)
  expect_equal(length(files), 4 * n_mcmc)
})

test_that("run_engine_contin() with no param files", {
  skip_paths()
  msg <- "please supply param files or a directory containing some."
  tmp <- tempfile()
  dir.create(tmp)
  skip_if_not_installed("withr")
  withr::with_dir(
    tmp, {
      file.create("abc")
      expect_error(
        run_engine_contin(param_files = "abc", n_sims = 1L, verbose = FALSE),
        regexp = msg
      )
      dir.create("x")
      file.create(file.path("x", "y"))
      for (f in c("x", file.path("x", "y"))) {
        expect_error(
          run_engine_contin(param_files = f, n_sims = 1L, verbose = FALSE),
          regexp = msg
        )
      }
    }
  )
})
