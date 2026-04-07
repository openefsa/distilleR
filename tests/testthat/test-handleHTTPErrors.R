test_that("The response parameter must be an httr2_response object", {
  expect_error(.handleHTTPErrors(response = 123))
})

test_that("The error message parameter must be a string", {
  expect_error(.handleHTTPErrors(
    response = httr2::response(),
    errorMessage = 123))
})

test_that("The function must fail for invalid error codes", {
  response_ <- httr2::response(
    status_code = 403,
    url = "https://example.org",
    method = "POST",
    headers = list("Content-Type" = "application/json"),
    body = charToRaw("{'a': 1}"))
  
  expect_error(
    .handleHTTPErrors(
      response = response_))
})

test_that("The function must succeed for valid error codes", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org",
    method = "GET",
    headers = list("Content-Type" = "application/json"),
    body = charToRaw("{\"a\": 1}"))
  
  expect_no_error(
    .handleHTTPErrors(
      response = response_))
})

# This test requires the DISTILLER_INSTANCE_URL and DISTILLER_API_KEY
# environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("The function must succeed for valid error codes", {
  skip_on_cran()
  
  request_ <- .buildAuthenticationRequest(
    distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
    distillerKey = Sys.getenv("DISTILLER_API_KEY"))
  
  response_ <- .performRequest(request = request_)
  
  expect_no_error(
    .handleHTTPErrors(
      response = response_))
})
