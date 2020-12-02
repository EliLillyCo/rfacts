test_that("trn()", {
  expect_equal(trn(TRUE, "x", "y"), "x")
  expect_equal(trn(FALSE, "x", "y"), "y")
})
