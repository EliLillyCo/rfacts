test_that("read_facts()", {
  facts_file <- get_facts_file_example("contin.facts")
  fields <- data.frame(
    field = c("my_subjects", "my_vsr"),
    type = c("NucleusParameterSet", "EfficacyParameterSet"),
    set = c("nucleus", "resp2"),
    property = c("max_subjects", "true_endpoint_response")
  )
  out <- read_facts(facts_file = facts_file, fields = fields)
  exp <- tibble::tibble(
    facts_file = facts_file,
    my_subjects = "300",
    my_vsr = list(c("0", "10"))
  )
  expect_equal(out, exp)
})
