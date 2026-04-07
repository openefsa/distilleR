test_that("The url must be a string", {
  expect_error(
    getAuthenticationToken(
      distillerInstanceUrl = 123,
      distillerKey = "DISTILLER_API_KEY"))
})

test_that("The API key must be a string", {
  expect_error(
    getAuthenticationToken(
      distillerInstanceUrl = "",
      distillerKey = 123))
})

test_that("The timeout must be an integer", {
  expect_error(
    getAuthenticationToken(
      distillerInstanceUrl = "",
      distillerKey = "DISTILLER_API_KEY",
      timeout = ""))
})

test_that("Expect no errors if the request succeeds", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/auth",
    method = "POST",
    headers = list("Content-Type" = "application/json"),
    body = charToRaw("{\"token\": \"DISTILLER_TOKEN\"}"))
  
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      return(response_)
    }, {
      expect_no_error(
        getAuthenticationToken(
          distillerInstanceUrl = "https://example.org",
          distillerKey = "DISTILLER_API_KEY"))
    }
  )
})

test_that("Expect an error if a bad endpoint is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      if (request$url == "https://example.org/auth") { stop() }
    }, {
      expect_error(
        getAuthenticationToken(
          distillerInstanceUrl = "https://example.org",
          distillerKey = "DISTILLER_API_KEY"))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL and DISTILLER_API_KEY
# environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad endpoint is specified", {
  skip_on_cran()
  
  distillerInstanceUrl_ <- Sys.getenv("DISTILLER_INSTANCE_URL")
  
  expect_error(
    getAuthenticationToken(
      distillerInstanceUrl = glue("{distillerInstanceUrl_}/bad_endpoint"),
      distillerKey = Sys.getenv("DISTILLER_API_KEY")))
})

test_that("Expect an error if a wrong API key is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      authorization_ <- rlang::wref_value(request$headers$Authorization)
      if (authorization_ == "Key BAD_API_KEY") { stop() }
    }, {
      expect_error(
        getAuthenticationToken(
          distillerInstanceUrl = "https://example.org",
          distillerKey = "BAD_API_KEY"))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL environment variable to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a wrong API key is specified", {
  skip_on_cran()
  
  distillerInstanceUrl_ <- Sys.getenv("DISTILLER_INSTANCE_URL")
  
  expect_error(
    getAuthenticationToken(
      distillerInstanceUrl = glue("{distillerInstanceUrl_}/bad_endpoint"),
      distillerKey = Sys.getenv("BAD_API_KEY")))
})
