test_that("The url must be a string", {
  expect_error(
    getProjects(
      distillerInstanceUrl = 123,
      distillerToken = "DISTILLER_TOKEN"))
})

test_that("The token must be a string", {
  expect_error(
    getProjects(
      distillerInstanceUrl = "https://example.org",
      distillerToken = 123))
})

test_that("The timeout must be an integer", {
  expect_error(
    getProjects(
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = ""))
})

test_that("Expect an error if a bad instance URL is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      if (request$url == "https://invalid_instance/projects") { stop() }
    }, {
      expect_error(
        getProjects(
          distillerInstanceUrl = "https://invalid_instance",
          distillerToken = "DISTILLER_TOKEN"))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL and DISTILLER_API_KEY
# environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad instance URL is specified", {
  skip_on_cran()
  
  distillerInstanceUrl_ <- "https://invalid_instance"
  distillerToken_ <- getAuthenticationToken()
  
  expect_error(
    getProjects(
      distillerInstanceUrl = distillerInstanceUrl_,
      distillerToken = distillerToken_))
})

test_that("Expect an error if a bad token is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      authorization_ <- rlang::wref_value(request$headers$Authorization)
      if (authorization_ == "Bearer BAD_TOKEN") { stop() }
    }, {
      expect_error(
        getProjects(
          distillerInstanceUrl = "https://example.org",
          distillerToken = "BAD_TOKEN"))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL environment variable to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad token is specified", {
  skip_on_cran()
  
  expect_error(
    getProjects(
      distillerToken = "BAD_TOKEN"))
})

test_that("A four-column tibble must be returned", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/projects",
    method = "GET",
    headers = list("Content-Type" = "application/json"),
    body = charToRaw("{\"a\": 1, \"b\": 2, \"c\": 3, \"d\": 4}"))
  
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      return(response_)
    }, {
      projects_ <- getProjects(
        distillerInstanceUrl = "https://example.org",
        distillerToken = "DISTILLER_TOKEN")
      
      expect_s3_class(projects_, "data.frame")
      expect_equal(ncol(projects_), 4)
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL and DISTILLER_API_KEY
# environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("A four-column tibble must be returned", {
  skip_on_cran()
  
  distillerToken_ <- getAuthenticationToken()
  
  projects_ <- getProjects(distillerToken = distillerToken_)
  
  expect_s3_class(projects_, "data.frame")
  expect_equal(ncol(projects_), 4)
})
