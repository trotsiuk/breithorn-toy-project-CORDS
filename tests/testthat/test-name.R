testthat::test_that("multiplication works", {
  testthat::expect_equal(2 * 2, 4)
})


# calculate_melt() --------------------------------------------------------
testthat::test_that("calculate_melt()", {
  testthat::expect_equal(calculate_melt(-10, melt_factor = 0.5), 0)
  testthat::expect_true(calculate_melt(10, melt_factor = 0.5) > 0)
  testthat::expect_equal(calculate_melt(10, melt_factor = 0.5), 5)
  testthat::expect_equal(calculate_melt(10, melt_factor = 0.2), 2)
})

