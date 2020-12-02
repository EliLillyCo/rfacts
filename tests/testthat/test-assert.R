test_that("assert_files_exist()", {
  expect_error(assert_files_exist(NULL))
  expect_error(assert_files_exist(123))
  expect_error(assert_files_exist(123))
  x <- tempfile()
  y <- tempfile()
  file.create(x)
  file.create(y)
  assert_files_exist(x)
  assert_files_exist(c(x, y))
  expect_error(assert_files_exist(c(x, "missing", y)))
})

test_that("assert_scalar_character()", {
  expect_silent(assert_scalar_character("123"))
  expect_error(assert_scalar_character(character(0)))
  expect_error(assert_scalar_character(letters))
  expect_error(assert_scalar_character(123))
  expect_error(assert_scalar_character(NULL))
})

test_that("assert_vector_character()", {
  expect_silent(assert_vector_character("123"))
  expect_silent(assert_vector_character(character(0)))
  expect_silent(assert_vector_character(letters))
  expect_error(assert_vector_character(123))
  expect_error(assert_vector_character(NULL))
})

test_that("assert_scalar_logical()", {
  expect_silent(assert_scalar_logical(TRUE))
  expect_silent(assert_scalar_logical(FALSE))
  expect_error(assert_scalar_logical(c(TRUE, FALSE)))
  expect_error(assert_scalar_logical(logical(0)))
  expect_error(assert_scalar_logical(1))
  expect_error(assert_scalar_logical(NULL))
})

test_that("assert_scalar_numeric()", {
  expect_silent(assert_scalar_numeric(1))
  expect_silent(assert_scalar_numeric(-2L))
  expect_error(assert_scalar_numeric(seq_len(3)))
  expect_error(assert_scalar_numeric(numeric(0)))
  expect_error(assert_scalar_numeric("600"))
  expect_error(assert_scalar_numeric(NULL))
})

test_that("assert_vector_numeric()", {
  expect_silent(assert_vector_numeric(1))
  expect_silent(assert_vector_numeric(-2L))
  expect_silent(assert_vector_numeric(seq_len(3)))
  expect_silent(assert_vector_numeric(numeric(0)))
  expect_error(assert_scalar_numeric("600"))
  expect_error(assert_scalar_numeric(letters))
  expect_error(assert_scalar_numeric(NULL))
})

test_that("assert_scalar()", {
  expect_silent(assert_scalar(1))
  expect_silent(assert_scalar("123"))
  expect_error(assert_scalar(seq_len(3)))
  expect_error(assert_scalar(numeric(0)))
  expect_error(assert_scalar_numeric(NULL))
})

test_that("assert_df()", {
  expect_silent(assert_df(data.frame(x = 1)))
  expect_error(assert_df(123))
})
