test_that("convert_character_columns()", {
  x <- data.frame(
    facts_file = "123",
    output = c("_facts/out1000.facts", "_facts/out2000.facts"),
    my_subjects = c(1000, 2000),
    stringsAsFactors = TRUE
  )
  x$lst <- list(c(1, 2), c(3, 4, 5))
  out <- convert_character_columns(x)
  exp <- data.frame(
    facts_file = "123",
    output = c("_facts/out1000.facts", "_facts/out2000.facts"),
    my_subjects = c("1000", "2000"),
    stringsAsFactors = FALSE
  )
  exp$lst <- list(c("1", "2"), c("3", "4", "5"))
  expect_equal(out, exp)
})

test_that("ensure_output_column() with output col already there", {
  exp <- data.frame(
    facts_file = "123",
    output = c("_facts/out1000.facts", "_facts/out2000.facts"),
    my_subjects = c(1000, 2000),
    stringsAsFactors = TRUE
  )
  out <- ensure_output_column(exp, default_dir = "_facts")
  expect_equal(out, exp)
})

test_that("ensure_output_column() with regular default dir", {
  x <- data.frame(
    facts_file = "123",
    my_subjects = c(1000, 2000),
    stringsAsFactors = TRUE
  )
  out <- ensure_output_column(x, default_dir = "_facts")
  expect_true(is.character(out$output))
  expect_true(all(dirname(out$output) == "_facts"))
  expect_true(all(dirname(out$output) == "_facts"))
  expect_true(all(grepl("\\.facts$", out$output)))
})

test_that("write_facts() to default path", {
  withr::with_dir(fs::dir_create(tempdir()), {
    facts_file <- get_facts_file_example("contin.facts")
    fields <- data.frame(
      field = "response",
      type = "EfficacyParameterSet",
      set = "resp2",
      property = "true_endpoint_response"
    )
    values <- data.frame(
      facts_file = rep(facts_file, 2),
      stringsAsFactors = FALSE
    )
    values$response <- list(c(0, 1000), c(0, 2000))
    files <- write_facts(fields = fields, values = values)
    skip_paths()
    expect_equal(sort(files), sort(file.path("_facts", list.files("_facts"))))
    expect_true(all(file.exists(files)))
    expect_true(all(dirname(files) == "_facts"))
    expect_true(all(grepl("\\.facts$", files)))
  })
})

test_that("length error replacing VSR", {
  facts_file <- get_facts_file_example("contin.facts")
  fields <- data.frame(
    field = "response",
    type = "EfficacyParameterSet",
    set = "resp2",
    property = "true_endpoint_response"
  )
  values <- data.frame(
    facts_file = facts_file,
    output = file.path(tempfile(), c("out1000.facts", "out2000.facts"))
  )
  values$response <- list(c(1), c(0, 2000))
  expect_error(
    write_facts(fields = fields, values = values),
    regexp = "item list"
  )
})

test_that("write_facts() change VSR", {
  facts_file <- get_facts_file_example("contin.facts")
  fields <- data.frame(
    field = "response",
    type = "EfficacyParameterSet",
    set = "resp2",
    property = "true_endpoint_response"
  )
  values <- data.frame(
    facts_file = facts_file,
    output = file.path(tempfile(), c("out1000.facts", "out2000.facts"))
  )
  values$response <- list(c(0, 1000), c(0, 2000))
  files <- write_facts(fields = fields, values = values)
  skip_paths()
  out <- read_patients(run_facts(facts_file, n_sims = 1))
  out_1 <- read_patients(run_facts(files[1], n_sims = 1))
  out_2 <- read_patients(run_facts(files[2], n_sims = 1))
  out1 <- dplyr::filter(
    out,
    facts_scenario == "acc1_drop1_resp1" & dose == 2
  )
  out11 <- dplyr::filter(
    out_1,
    facts_scenario == "acc1_drop1_resp1" & dose == 2
  )
  out12 <- dplyr::filter(
    out_2,
    facts_scenario == "acc1_drop1_resp1" & dose == 2
  )
  expect_lt(mean(out1$visit_1), 30)
  expect_lt(mean(out11$visit_1), 30)
  expect_lt(mean(out12$visit_1), 30)
  out1 <- dplyr::filter(
    out,
    facts_scenario == "acc1_drop1_resp1" & dose == 1
  )
  out11 <- dplyr::filter(
    out_1,
    facts_scenario == "acc1_drop1_resp1" & dose == 1
  )
  out12 <- dplyr::filter(
    out_2,
    facts_scenario == "acc1_drop1_resp1" & dose == 1
  )
  expect_lt(mean(out1$visit_1), 30)
  expect_lt(mean(out11$visit_1), 30)
  expect_lt(mean(out12$visit_1), 30)
  out2 <- dplyr::filter(
    out,
    facts_scenario == "acc1_drop1_resp2" & dose == 2
  )
  out21 <- dplyr::filter(
    out_1,
    facts_scenario == "acc1_drop1_resp2" & dose == 2
  )
  out22 <- dplyr::filter(
    out_2,
    facts_scenario == "acc1_drop1_resp2" & dose == 2
  )
  expect_lt(mean(out2$visit_1), 30)
  expect_lt(mean(out21$visit_1), 1030)
  expect_lt(mean(out22$visit_1), 2030)
  expect_gt(mean(out21$visit_1), 970)
  expect_gt(mean(out22$visit_1), 1970)
  out1 <- dplyr::filter(
    out,
    facts_scenario == "acc1_drop1_resp2" & dose == 1
  )
  out11 <- dplyr::filter(
    out_1,
    facts_scenario == "acc1_drop1_resp2" & dose == 1
  )
  out12 <- dplyr::filter(
    out_2,
    facts_scenario == "acc1_drop1_resp2" & dose == 1
  )
  expect_lt(mean(out1$visit_1), 30)
  expect_lt(mean(out11$visit_1), 30)
  expect_lt(mean(out12$visit_1), 30)
})

test_that("write_facts() max_subjects and analysis prior", {
  facts_file <- get_facts_file_example("contin.facts")
  fields <- rbind(
    data.frame(
      field = "analysis_prior",
      type = "NucleusParameterSet",
      set = "nucleus",
      property = "control_prior",
      stringsAsFactors = FALSE
    ),
    data.frame(
      field = "my_subjects",
      type = "NucleusParameterSet",
      set = "nucleus",
      property = "max_subjects"
    )
  )
  values <- data.frame(
    facts_file = facts_file,
    output = file.path(tempfile(), c("out1000.facts", "out2000.facts")),
    my_subjects = c(1000, 2000),
    stringsAsFactors = FALSE
  )
  values$analysis_prior <- list(c(1, 3), c(2, 4))
  files <- write_facts(fields = fields, values = values)
  field <- data.frame(
    field = "analysis_prior",
    type = "NucleusParameterSet",
    set = "nucleus",
    property = "control_prior",
    stringsAsFactors = FALSE
  )
  get_prior <- function(file) {
    xml <- xml2::read_xml(file)
    property <- xml2::xml_find_first(xml, get_xpath(field))
    xml2::as_list(property)[[1]]
  }
  prior0 <- get_prior(facts_file)
  prior1 <- get_prior(files[1])
  prior2 <- get_prior(files[2])
  expect_equal(unlist(prior0$mean), "0")
  expect_equal(unlist(prior1$mean), "1")
  expect_equal(unlist(prior2$mean), "2")
  expect_equal(unlist(prior0$sd), "10")
  expect_equal(unlist(prior1$sd), "3")
  expect_equal(unlist(prior2$sd), "4")
  skip_paths()
  out <- read_patients(run_facts(facts_file, n_sims = 1))
  out1 <- read_patients(run_facts(files[1], n_sims = 1))
  out2 <- read_patients(run_facts(files[2], n_sims = 1))
  expect_equal(nrow(out), 1200L)
  expect_equal(nrow(out1), 4000L)
  expect_equal(nrow(out2), 8000L)
})
