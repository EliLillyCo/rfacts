test_that("aipf_contin", {
  skip_paths()
  facts_file <- get_facts_file_example("aipf_contin.facts")
  out <- run_facts(
    facts_file,
    n_sims = 1L,
    verbose = FALSE
  )
  files <- list.files(
    out,
    pattern = "patients[0-9]+\\.csv$",
    recursive = TRUE
  )
  expect_equal(length(files), 1L)
})

test_that("aipf_dichot", {
  skip_paths()
  facts_file <- get_facts_file_example("aipf_dichot.facts")
  out <- run_facts(
    facts_file,
    n_sims = 1L,
    verbose = FALSE
  )
  files <- list.files(
    out,
    pattern = "patients[0-9]+\\.csv$",
    recursive = TRUE
  )
  expect_equal(length(files), 1L)
})

test_that("aipf_tte", {
  skip_paths()
  facts_file <- get_facts_file_example("aipf_tte.facts")
  out <- run_facts(
    facts_file,
    n_sims = 1L,
    verbose = FALSE
  )
  files <- list.files(
    out,
    pattern = "patients[0-9]+\\.csv$",
    recursive = TRUE
  )
  expect_equal(length(files), 1L)
})

test_that("contin", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_facts(
    facts_file,
    n_sims = 1L,
    verbose = FALSE
  )
  files <- list.files(
    out,
    pattern = "patients[0-9]+\\.csv$",
    recursive = TRUE
  )
  expect_equal(length(files), 4L)
})

test_that("crm", {
  skip_paths()
  facts_file <- get_facts_file_example("crm.facts")
  out <- run_facts(
    facts_file,
    n_sims = 3L,
    verbose = FALSE
  )
  files <- list.files(
    out,
    pattern = "cohorts[0-9]+\\.csv$",
    recursive = TRUE
  )
  expect_equal(length(files), 3L)
})

test_that("dichot", {
  skip_paths()
  facts_file <- get_facts_file_example("dichot.facts")
  out <- run_facts(
    facts_file,
    n_sims = 1L,
    verbose = FALSE
  )
  files <- list.files(
    out,
    pattern = "patients[0-9]+\\.csv$",
    recursive = TRUE
  )
  expect_equal(length(files), 4L)
})

test_that("multep", {
  skip_paths()
  facts_file <- get_facts_file_example("multep.facts")
  out <- run_facts(
    facts_file,
    n_sims = 1L,
    verbose = FALSE
  )
  files <- list.files(
    out,
    pattern = "patients[0-9]+\\.csv$",
    recursive = TRUE
  )
  expect_equal(length(files), 1L)
})

test_that("staged and parallel", {
  skip_paths()
  facts_file <- get_facts_file_example("staged.facts")
  out <- run_flfll(facts_file, verbose = FALSE)
  param_files <- prep_param_files(out)
  parallel::mclapply(
    param_files,
    run_engine_dichot,
    mc.cores = 2L,
    n_sims = 1L,
    verbose = FALSE
  )
  files <- list.files(
    out,
    pattern = "patients[0-9]+\\.csv$",
    recursive = TRUE
  )
  expect_equal(length(files), 6L)
})

test_that("tte", {
  skip_paths()
  facts_file <- get_facts_file_example("tte.facts")
  out <- run_facts(
    facts_file,
    n_sims = 1L,
    verbose = FALSE
  )
  files <- list.files(
    out,
    pattern = "patients[0-9]+\\.csv$",
    recursive = TRUE
  )
  expect_equal(length(files), 4L)
})
