test_that("if_any()", {
  expect_equal(if_any(TRUE, "x", "y"), "x")
  expect_equal(if_any(FALSE, "x", "y"), "y")
})

test_that("choose_version()", {
  expect_equal(choose_version("a", NULL), character(0))
  expect_equal(choose_version(NULL, letters), max(letters))
  expect_equal(choose_version(1L, c(10L, 20L, 30L)), 10L)
  expect_equal(choose_version("b", letters), "b")
})
