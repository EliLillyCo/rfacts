test_that("get_param_dirs", {
  skip_paths()
  facts_file <- get_facts_file_example("contin.facts")
  exp <- c(
    "acc1_drop1_resp1",
    "acc1_drop1_resp2",
    "acc2_drop1_resp1",
    "acc2_drop1_resp2"
  )
  out <- run_flfll(facts_file, verbose = FALSE)
  dirs <- get_param_dirs(out)
  expect_true(all(file.exists(dirs)))
  expect_equal(sort(basename(dirs)), paste0(sort(exp), "_params"))
})
