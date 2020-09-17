test_that("arg_character()", {
  expect_equal(arg_character("--flag", NULL), character(0))
  expect_equal(arg_character("--flag", "xyz"), c("--flag", "xyz"))
  expect_equal(arg_character("--flag", "a\tb c"), c("--flag", "a\tb c"))
  expect_error(arg_character("--flag", 123))
  expect_error(arg_character("--flag", letters))
})

test_that("arg_path()", {
  expect_equal(arg_path("--flag", NULL), character(0))
  expect_equal(arg_path("--flag", "xyz"), c("--flag", "xyz"))
  expect_equal(arg_path("--flag", "a\tb c"), c("--flag", "a\\ b\\ c"))
  expect_error(arg_path("--flag", pi))
  expect_error(arg_path("--flag", letters))
})

test_that("arg_logical()", {
  expect_equal(arg_logical("--flag", NULL), character(0))
  expect_equal(arg_logical("--flag", FALSE), character(0))
  expect_equal(arg_logical("--flag", TRUE), "--flag")
  expect_error(arg_logical("--flag", 123))
  expect_error(arg_logical("--flag", c(TRUE, FALSE)))
})

test_that("arg_integer()", {
  expect_equal(arg_integer("--flag", NULL), character(0))
  expect_equal(arg_integer("--flag", pi), c("--flag", "3"))
  expect_error(arg_integer("--flag", "abc"))
  expect_error(arg_integer("--flag", seq_len(3)))
})

test_that("arg_integer_csv()", {
  expect_equal(arg_integer_csv("--flag", NULL), character(0))
  expect_equal(arg_integer_csv("--flag", 123.456), c("--flag", "123"))
  expect_equal(arg_integer_csv("--flag", seq_len(3)), c("--flag", "1,2,3"))
  expect_error(arg_integer_csv("--flag", "abc"))
})

test_that("arg_numeric()", {
  expect_equal(arg_numeric("--flag", NULL), character(0))
  expect_equal(arg_numeric("--flag", 123.456), c("--flag", "123.456"))
  expect_error(arg_numeric("--flag", "abc"))
  expect_error(arg_numeric("--flag", seq_len(3)))
})
