test_that("The number of seconds must be an integer", {
  expect_error(
    .sleep("1"))
})

test_that("Expect no errors if the number of seconds is correct", {
  expect_no_error(
    .sleep(1))
})
