test_that("prep_param_files()", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_flfll(facts_file, verbose = FALSE)
  params <- prep_param_files(out)
  msg <- capture.output(print(params))
  run_engine_contin(params, n_sims = 2, verbose = FALSE, version = "6.2.5")
  out2 <- run_flfll(facts_file, verbose = FALSE)
  run_engine_contin(out2, n_sims = 2, verbose = FALSE, version = "6.2.5")
  out3 <- run_flfll(facts_file, verbose = FALSE)
  params3 <- prep_param_files(out3)
  lapply(
    params3,
    run_engine_contin,
    n_sims = 2,
    verbose = FALSE,
    version = "6.2.5"
  )
  pats1 <- read_patients(out)
  pats2 <- read_patients(out2)
  pats3 <- read_patients(out3)
  for (col in exempt_cols()) {
    pats1[[col]] <- pats2[[col]] <- pats3[[col]] <- NULL
  }
  expect_equal(pats1, pats2)
  expect_equal(pats1, pats3)
})
