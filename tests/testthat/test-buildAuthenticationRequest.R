test_that("The URL must be a string", {
  expect_error(
    .buildAuthenticationRequest(
      distillerInstanceUrl = 123,
      distillerKey = "DISTILLER_API_KEY"))
})

test_that("The API key must be a string", {
  expect_error(
    .buildAuthenticationRequest(
      distillerInstanceUrl = "https://example.org",
      distillerKey = 123))
})

test_that("The timeout must be an integer", {
  expect_error(
    .buildAuthenticationRequest(
      distillerInstanceUrl = "https://example.org",
      distillerKey = "DISTILLER_API_KEY",
      timeout = ""))
})

test_that("The result must be a httr2_request", {
  expect_s3_class(
    .buildAuthenticationRequest(
      distillerInstanceUrl = "https://example.org",
      distillerKey = "DISTILLER_API_KEY"),
    "httr2_request")
})
