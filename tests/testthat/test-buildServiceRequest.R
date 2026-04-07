test_that("The URL must be a string", {
  expect_error(
    .buildServiceRequest(
      serviceUrl = 123,
      distillerToken = "DISTILLER_TOKEN"))
})

test_that("The token must be a string", {
  expect_error(
    .buildServiceRequest(
      serviceUrl = "https://example.org/service",
      distillerToken = 123))
})

test_that("The body must be a list", {
  expect_error(
    .buildServiceRequest(
      serviceUrl = "https://example.org/service",
      distillerToken = "DISTILLER_TOKEN",
      body = 123))
})

test_that("The timeout must be an integer", {
  expect_error(
    .buildServiceRequest(
      serviceUrl = "https://example.org/service",
      distillerToken = "DISTILLER_TOKEN",
      timeout = ""))
})

test_that("The result must be a httr2_request", {
  expect_s3_class(
    .buildServiceRequest(
      serviceUrl = "https://example.org/service",
      distillerToken = "DISTILLER_TOKEN",
      body = list("a" = 1)),
    "httr2_request")
})
