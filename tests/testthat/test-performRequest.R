test_that("The request parameter must be an httr2_request object", {
  expect_error(
    .performRequest(
      request = 123))
})

test_that("The error message parameter must be a string", {
  expect_error(
    .performRequest(
      request = httr2::request(),
      errorMessage = 123))
})

test_that("Expect an error if the request is malformed", {
  request_ <- .buildAuthenticationRequest(
    distillerInstanceUrl = "https://invalid_domain",
    distillerKey = "api_key")
  
  expect_error(
    .performRequest(
      request = request_))
})

test_that("Expect no error if the request object is correct", {
  request_ <- .buildAuthenticationRequest(
    distillerInstanceUrl = "DISTILLER_INSTANCE_URL",
    distillerKey = "DISTILLER_API_KEY")
  
  response_ <- httr2::response(
    status_code = 200)
  
  with_mocked_bindings(
    req_perform = function(request) {
      return(response_)
    }, {
      expect_no_error(
        .performRequest(
          request = request_))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL and DISTILLER_API_KEY
# environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect no error if the request object is correct", {
  skip_on_cran()
  
  request_ <- .buildAuthenticationRequest(
    distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
    distillerKey = Sys.getenv("DISTILLER_API_KEY"))
  
  expect_no_error(
    .performRequest(
      request = request_))
})

test_that("The result must be an httr2_response object", {
  request_ <- .buildAuthenticationRequest(
    distillerInstanceUrl = "DISTILLER_INSTANCE_URL",
    distillerKey = "DISTILLER_API_KEY")
  
  response_ <- httr2::response(
    status_code = 200)
  
  with_mocked_bindings(
    req_perform = function(request) {
      return(response_)
    }, {
      expect_s3_class(
        .performRequest(
          request = request_),
        "httr2_response")
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL and DISTILLER_API_KEY
# environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("The result must be an httr2_response object", {
  skip_on_cran()
  
  request_ <- .buildAuthenticationRequest(
    distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
    distillerKey = Sys.getenv("DISTILLER_API_KEY"))
  
  expect_s3_class(
    .performRequest(
      request = request_),
    "httr2_response")
})
