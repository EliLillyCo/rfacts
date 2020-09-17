test_that("get_facts_versions()", {
  skip_paths()
  out <- get_facts_versions()
  expect_true(is.character(out))
  expect_true(length(out) > 0L)
})

test_that("get_facts_version()", {
  files <- setdiff(list_facts_files(), "old.facts")
  for (facts_file in files) {
    expect_equal(
      get_facts_version(get_facts_file_example(facts_file)),
      "6.2.5.22668"
    )
  }
})

test_that("get_facts_scenarios", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  out <- get_facts_scenarios(facts_file)
  exp <- c(
    "acc1_drop1_resp1",
    "acc1_drop1_resp2",
    "acc2_drop1_resp1",
    "acc2_drop1_resp2"
  )
  expect_equal(sort(out), sort(exp))
})

test_that("get_facts_param_set()", {
  expect_equal(
    get_facts_param_set(get_facts_file_example("contin.facts")),
    "NucleusParameterSet"
  )
  expect_equal(
    get_facts_param_set(get_facts_file_example("crm.facts")),
    "CRMDesignParamSet"
  )
  expect_equal(
    get_facts_param_set(get_facts_file_example("dichot.facts")),
    "NucleusParameterSet"
  )
  expect_equal(
    get_facts_param_set(get_facts_file_example("multep.facts")),
    "MultipleEndpointParameterSet"
  )
  expect_equal(
    get_facts_param_set(get_facts_file_example("staged.facts")),
    "SDBaseParameterSet"
  )
  expect_equal(
    get_facts_param_set(get_facts_file_example("tte.facts")),
    "TTEDesignParameterSet"
  )
})

test_that("get_facts_param_type()", {
  expect_equal(
    get_facts_param_type(get_facts_file_example("contin.facts")),
    "1"
  )
  expect_equal(
    get_facts_param_type(get_facts_file_example("crm.facts")),
    "0"
  )
  expect_equal(
    get_facts_param_type(get_facts_file_example("dichot.facts")),
    "2"
  )
  expect_equal(
    get_facts_param_type(get_facts_file_example("multep.facts")),
    "1"
  )
  expect_equal(
    get_facts_param_type(get_facts_file_example("staged.facts")),
    "2"
  )
  expect_equal(
    get_facts_param_type(get_facts_file_example("tte.facts")),
    "3"
  )
})

test_that("get_engine_impl() failure", {
  skip_paths()
  expect_error(
    get_engine_impl(
      set = "bad",
      type = "bad",
      version = "bad",
      field = "path"
    ),
    regexp = "compatible"
  )
})

test_that("get_engine_impl() contin 6.2.5", {
  old_rfacts_paths <- Sys.getenv("RFACTS_PATHS")
  Sys.setenv(RFACTS_PATHS = "paths.csv")
  old_paths <- .rfacts$paths
  reset_rfacts_paths()
  on.exit({
    Sys.setenv(RFACTS_PATHS = old_rfacts_paths)
    .rfacts$paths <- old_paths
  })
  for (version in c("6.2.5", "999.999.999")) {
    out <- get_engine_impl(
      set = "NucleusParameterSet",
      type = "1",
      version = version,
      field = "path"
    )
    expect_equal(out, facts_engine_625("contin.x"))
  }
})

test_that("get_engine_impl() contin low version", {
  old_rfacts_paths <- Sys.getenv("RFACTS_PATHS")
  Sys.setenv(RFACTS_PATHS = "paths.csv")
  old_paths <- .rfacts$paths
  reset_rfacts_paths()
  on.exit({
    Sys.setenv(RFACTS_PATHS = old_rfacts_paths)
    .rfacts$paths <- old_paths
  })
  for (version in c("6.0.0.1", "6.0.5")) {
    out <- get_engine_impl(
      set = "NucleusParameterSet",
      type = "1",
      version = version,
      field = "path"
    )
    expect_equal(out, facts_engine_6001("contin.x"))
  }
})

test_that("get_engine_impl() dichot", {
  old_rfacts_paths <- Sys.getenv("RFACTS_PATHS")
  Sys.setenv(RFACTS_PATHS = "paths.csv")
  old_paths <- .rfacts$paths
  reset_rfacts_paths()
  on.exit({
    Sys.setenv(RFACTS_PATHS = old_rfacts_paths)
    .rfacts$paths <- old_paths
  })
  out <- get_engine_impl(
    set = "NucleusParameterSet",
    type = "2",
    version = "6.2.5",
    field = "path"
  )
  expect_equal(out, facts_engine_625("dichot.x"))
})

test_that("get_engine_impl() multep", {
  old_rfacts_paths <- Sys.getenv("RFACTS_PATHS")
  Sys.setenv(RFACTS_PATHS = "paths.csv")
  old_paths <- .rfacts$paths
  reset_rfacts_paths()
  on.exit({
    Sys.setenv(RFACTS_PATHS = old_rfacts_paths)
    .rfacts$paths <- old_paths
  })
  out <- get_engine_impl(
    set = "MultipleEndpointParameterSet",
    type = "1",
    version = "6.2.5",
    field = "path"
  )
  expect_equal(out, facts_engine_625("multep.x"))
})

test_that("get_engine_impl() tte", {
  old_rfacts_paths <- Sys.getenv("RFACTS_PATHS")
  Sys.setenv(RFACTS_PATHS = "paths.csv")
  old_paths <- .rfacts$paths
  reset_rfacts_paths()
  on.exit({
    Sys.setenv(RFACTS_PATHS = old_rfacts_paths)
    .rfacts$paths <- old_paths
  })
  out <- get_engine_impl(
    set = "TTEDesignParameterSet",
    type = "3",
    version = "6.2.5",
    field = "path"
  )
  expect_equal(out, facts_engine_625("tte.x"))
})

test_that("get_engine_path() crm", {
  old_rfacts_paths <- Sys.getenv("RFACTS_PATHS")
  Sys.setenv(RFACTS_PATHS = "paths.csv")
  old_paths <- .rfacts$paths
  reset_rfacts_paths()
  on.exit({
    Sys.setenv(RFACTS_PATHS = old_rfacts_paths)
    .rfacts$paths <- old_paths
  })
  out <- get_engine_impl(
    set = "CRMDesignParamSet",
    type = "0",
    version = "6.2.5",
    field = "path"
  )
  expect_equal(out, facts_engine_625("CRM.x"))
})

test_that("get_engine_path()", {
  old_rfacts_paths <- Sys.getenv("RFACTS_PATHS")
  Sys.setenv(RFACTS_PATHS = "paths.csv")
  old_paths <- .rfacts$paths
  reset_rfacts_paths()
  on.exit({
    Sys.setenv(RFACTS_PATHS = old_rfacts_paths)
    .rfacts$paths <- old_paths
  })
  expect_equal(
    get_engine_path(get_facts_file_example("contin.facts")),
    facts_engine_625("contin.x")
  )
  expect_equal(
    get_engine_path(get_facts_file_example("crm.facts")),
    facts_engine_625("CRM.x")
  )
  expect_equal(
    get_engine_path(get_facts_file_example("dichot.facts")),
    facts_engine_625("dichot.x")
  )
  expect_equal(
    get_engine_path(get_facts_file_example("multep.facts")),
    facts_engine_625("multep.x")
  )
  expect_equal(
    get_engine_path(get_facts_file_example("staged.facts")),
    facts_engine_625("dichot.x")
  )
  expect_equal(
    get_engine_path(get_facts_file_example("tte.facts")),
    facts_engine_625("tte.x")
  )
})

test_that("get_facts_engine()", {
  old_rfacts_paths <- Sys.getenv("RFACTS_PATHS")
  Sys.setenv(RFACTS_PATHS = "paths.csv")
  old_paths <- .rfacts$paths
  reset_rfacts_paths()
  on.exit({
    Sys.setenv(RFACTS_PATHS = old_rfacts_paths)
    .rfacts$paths <- old_paths
  })
  expect_equal(
    get_facts_engine(get_facts_file_example("contin.facts")),
    "run_engine_contin"
  )
})
