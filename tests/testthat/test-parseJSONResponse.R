test_that("The response parameter must be an httr2_response object", {
  expect_error(
    .parseJSONResponse(
      response = 123))
})

test_that("The error message parameter must be a string", {
  expect_error(
    .parseJSONResponse(
      response = httr2::response(),
      errorMessage = 123))
})

test_that("Expect an error if the response delivers invalid data", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/endpoint",
    method = "POST",
    headers = list("Content-Type" = "application/json"),
    body = charToRaw("{'a': 1,"))
  
  expect_error(
    .parseJSONResponse(
      response = response_))
})

test_that("Expect no error if all the parameters are correct", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/endpoint",
    method = "POST",
    headers = list("Content-Type" = "application/json"),
    body = charToRaw("{\"a\": 1}"))
  
  expect_no_error(
    .parseJSONResponse(
      response = response_))
})
