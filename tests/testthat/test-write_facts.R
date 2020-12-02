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

test_that("write_facts(), scalar and default files", {
  facts_file <- get_facts_file_example("contin.facts")
  fields <- data.frame(
    field = "my_subjects",
    type = "NucleusParameterSet",
    set = "nucleus",
    property = "max_subjects"
  )
  values <- data.frame(
    facts_file = facts_file,
    output = file.path(tempfile(), c("out1000.facts", "out2000.facts")),
    my_subjects = c(1000, 2000)
  )
  write_facts(fields = fields, values = values)
})
