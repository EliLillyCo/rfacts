test_that("get_csv_files()", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  csv_files <- run_facts(
    facts_file,
    n_sims = 1,
    verbose = FALSE
  )
  out <- get_csv_files(csv_files, numbered = FALSE)
  expect_true(any(grepl("simulations\\.csv", out)))
  expect_false(any(grepl("patients00001\\.csv", out)))
  out <- get_csv_files(csv_files, numbered = TRUE)
  expect_false(any(grepl("simulations\\.csv", out)))
  expect_true(any(grepl("patients00001\\.csv", out)))
})

test_that("read_patients(), no files", {
  expect_message(read_patients(tempfile()), "No CSV files")
})

test_that("read_csv_special() cannot read summaries", {
  expect_error(
    read_csv_special(tempfile(), "summaries"),
    "do not try to read summary"
  )
})

test_that("read_patients() csv_files arg + pats cols", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out1 <- run_facts(
    facts_file,
    n_sims = 1,
    verbose = FALSE,
    seed = 1
  )
  out2 <- run_facts(
    facts_file,
    n_sims = 1,
    verbose = FALSE,
    seed = 2
  )
  pats1 <- read_patients(out1)
  pats2 <- read_patients(out2)
  pats11 <- read_patients(c(out1, out1))
  pats12 <- read_patients(c(out1, out2))
  for (col in exempt_cols()) {
    pats1[[col]] <-
      pats2[[col]] <-
      pats11[[col]] <-
      pats12[[col]] <- NULL
  }
  expect_equal(pats1, pats11)
  expect_equal(pats12, rbind(pats1, pats2))
  files <- unique(unlist(lapply(out1, get_files, pattern = "[0-9]+\\.csv$")))
  files <- grep("patients", files, value = TRUE)
  patsf <- read_patients(files)
  for (col in exempt_cols()) {
    patsf[[col]] <- NULL
  }
  expect_equal(pats1, patsf)
  expect_equal(nrow(pats1), 1200L)
  expect_equal(ncol(pats1), 12L)
  cols <- c(
    "facts_file",
    "facts_scenario",
    "facts_sim",
    "facts_output",
    "subject",
    "region",
    "date",
    "dose",
    "lastvisit",
    "dropout",
    "baseline",
    "visit_1"
  )
  expect_true(all(cols %in% colnames(pats1)))
  out <- unique(pats1$facts_scenario)
  exp <- c(
    "acc1_drop1_resp1",
    "acc1_drop1_resp2",
    "acc2_drop1_resp1",
    "acc2_drop1_resp2"
  )
  expect_equal(sort(out), sort(exp))
})

test_that("read_weeks() + read_csv_special()", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out_dir <- run_facts(
    facts_file,
    n_sims = 1,
    verbose = FALSE,
    seed = 1
  )
  out <- read_weeks(out_dir)
  cols <- c(
    "facts_file",
    "facts_scenario",
    "facts_sim",
    "facts_output",
    "facts_id",
    "facts_csv",
    "facts_header",
    "interimnumber",
    "subjects",
    "outcome"
  )
  expect_true(all(cols %in% colnames(out)))
  out2 <- read_csv_special(out_dir, prefix = "weeks")
  for (col in exempt_cols()) {
    out[[col]] <- out2[[col]] <- NULL
  }
  expect_equal(out, out2)
  expect_equal(dim(out), c(4L, 86L))
  sims <- read_csv_special(out_dir, prefix = "simulations", numbered = FALSE)
  expect_equal(dim(sims), c(4L, 89L))
  expect_equal(sims$sim, rep(1, 4))
  expect_true(all(is.na(sims$facts_sim)))
  sims2 <- read_simulations(out_dir)
  for (col in exempt_cols()) {
    sims[[col]] <- sims2[[col]] <- NULL
  }
  expect_equal(sims, sims2)
})

test_that("read_mcmc()", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_facts(
    facts_file,
    n_sims = 1,
    verbose = FALSE,
    n_mcmc_files = 1,
    seed = 1
  )
  out <- read_mcmc(out)
  expect_equal(dim(out), c(14000L, 13L))
  cols <- c(
    "facts_file",
    "facts_scenario",
    "facts_sim",
    "facts_output",
    "facts_id",
    "facts_csv",
    "facts_header",
    "analysis",
    "sample",
    "theta_1",
    "theta_2",
    "sigma",
    "tau"
  )
  expect_true(all(cols %in% colnames(out)))
})

test_that("read_cohorts()", {
  skip_paths()
  facts_file <- get_facts_file_example("crm.facts")
  out <- run_facts(
    facts_file,
    n_sims = 1,
    verbose = FALSE
  )
  out <- read_cohorts(out)
  expect_equal(dim(out), c(11, 128L))
  cols <- c(
    "facts_file",
    "facts_scenario",
    "facts_sim",
    "facts_id",
    "facts_csv",
    "facts_header",
    "facts_output",
    "cohort",
    "cohort_size",
    "mtd",
    "numtoxic"
  )
  expect_true(all(cols %in% colnames(out)))
  expect_equal(unique(out$facts_scenario), "ToxParam 1")
})

test_that("read_*() with staged design", {
  skip_paths()
  facts_file <- get_facts_file_example("staged.facts")
  out_dir <- run_facts(
    facts_file,
    n_sims = 1,
    n_weeks_files = 1,
    n_mcmc_files = 1,
    n_patients_files = 1,
    verbose = FALSE
  )
  out_csv <- list(
    s1_mcmc = read_s1_mcmc(out_dir),
    s1_patients = read_s1_patients(out_dir),
    s1_weeks = read_s1_weeks(out_dir),
    s2_mcmc = read_s2_mcmc(out_dir),
    s2_patients = read_s2_patients(out_dir),
    s2_weeks = read_s2_weeks(out_dir),
    master_mcmc = read_master_mcmc(out_dir),
    master_patients = read_master_patients(out_dir),
    master_weeks = read_master_weeks(out_dir)
  )
  cols <- c(
    "facts_file",
    "facts_scenario",
    "facts_sim",
    "facts_output",
    "facts_id",
    "facts_csv",
    "facts_header"
  )
  lapply(out_csv, function(out) {
    expect_true(all(dim(out) > 0L))
    expect_true(all(cols %in% colnames(out)))
  })
})

test_that("overwrite_csv_files() overwrites files", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_facts(facts_file, n_sims = 2)
  pats1 <- read_patients(out)
  expect_true(all(is.na(pats1$baseline)))
  file <- grep("patients00002", get_csv_files(out), value = TRUE)[3]
  unlink(file)
  expect_false(file.exists(file))
  pats1$visit_1 <- 0
  overwrite_csv_files(pats1)
  expect_true(file.exists(file))
  df <- utils::read.table(file, sep = ",", stringsAsFactors = FALSE)
  tmp <- lapply(df, function(col) {
    expect_false(any(is.na(col)))
  })
  expect_true(all(df$V7 == -9999L))
  pats2 <- read_patients(out)
  expect_equal(pats2$visit_1, rep(0, nrow(pats2)))
  for (col in c(exempt_cols(), "visit_1")) {
    pats1[[col]] <- pats2[[col]] <- NULL
  }
  expect_equal(pats1, pats2)
})

test_that("overwrite_csv_files() does not mangle CSV files", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- run_facts(facts_file, n_sims = 2)
  file <- grep("patients00002", get_csv_files(out), value = TRUE)[3]
  tmp <- tempfile()
  file.copy(file, tmp)
  pats1 <- read_patients(out)
  unlink(file)
  expect_false(file.exists(file))
  overwrite_csv_files(pats1)
  expect_true(file.exists(file))
  x <- readLines(tmp)
  y <- readLines(file)
  x <- gsub(" ", "", x)
  y <- gsub(" ", "", y)
  expect_true(all(x == y))
})
