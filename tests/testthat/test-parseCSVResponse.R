test_that("The response parameter must be an httr2_response object", {
  expect_error(
    .parseCSVResponse(
      response = 123))
})

test_that("The error message parameter must be a string", {
  expect_error(
    .parseCSVResponse(
      response = httr2::response(),
      errorMessage = 123))
})

test_that("The verbose flag must be a logical", {
  expect_error(
    .parseCSVResponse(
      response = httr2::response(),
      errorMessage = "",
      verbose = 123))
})

test_that("The output must be a dataframe", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/endpoint",
    method = "POST",
    headers = list("Content-Type" = "text/csv"),
    body = charToRaw("a,b,c\n1,2,3"))
  
  expect_s3_class(
    .parseCSVResponse(
      response = response_, verbose = FALSE),
    "data.frame")
})

test_that("Expect an error if the response delivers invalid data", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/endpoint",
    method = "POST",
    headers = list(
      "Content-Type" = "text/csv"),
    body = charToRaw("invalid CSV data"))
  
  expect_error(
    .parseCSVResponse(
      response = response_))
})
