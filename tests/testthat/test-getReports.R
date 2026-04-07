test_that("The project ID must be an integer", {
  expect_error(
    getReports(
      projectId = "",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN"))
})

test_that("The url must be a string", {
  expect_error(
    getReports(
      projectId = 123,
      distillerInstanceUrl = 123,
      distillerToken = "DISTILLER_TOKEN"))
})

test_that("The token must be a string", {
  expect_error(
    getReports(
      projectId = 123,
      distillerInstanceUrl = "https://example.org",
      distillerToken = 123))
})

test_that("The timeout must be an integer", {
  expect_error(
    getReports(
      projectId = 123,
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = ""))
})

test_that("Expect an error if a bad instance URL is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      invalidUrl_ <- "https://invalid_instance/projects/123/reports/datarama"
      if (request$url == invalidUrl_) { stop() }
    }, {
      expect_error(
        getReports(
          projectId = 123,
          distillerInstanceUrl = "https://invalid_instance",
          distillerToken = "DISTILLER_TOKEN"))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL, DISTILLER_API_KEY, and
# DISTILLER_PROJECT_ID_TEST environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad instance URL is specified", {
  skip_on_cran()
  
  distillerInstanceUrl_ <- "https://invalid_instance"
  distillerToken_ <- getAuthenticationToken()
  distillerProjectId_ <- Sys.getenv("DISTILLER_PROJECT_ID_TEST")
  
  expect_error(
    getReports(
      projectId = as.integer(distillerProjectId_),
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
        getReports(
          projectId = 123,
          distillerInstanceUrl = "https://example.org",
          distillerToken = "BAD_TOKEN"))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL and DISTILLER_PROJECT_ID_TEST
# environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad token is specified", {
  skip_on_cran()
  
  distillerProjectId_ <- Sys.getenv("DISTILLER_PROJECT_ID_TEST")
  
  expect_error(
    getReports(
      projectId = as.integer(distillerProjectId_),
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
      reports_ <- getReports(
        projectId = 123,
        distillerInstanceUrl = "https://example.org",
        distillerToken = "DISTILLER_TOKEN")
      
      expect_s3_class(reports_, "data.frame")
      expect_equal(ncol(reports_), 4)
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL, DISTILLER_API_KEY, and
# DISTILLER_PROJECT_ID_TEST environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("A four-column tibble must be returned", {
  skip_on_cran()
  
  distillerToken_ <- getAuthenticationToken()
  distillerProjectId_ <- Sys.getenv("DISTILLER_PROJECT_ID_TEST")
  
  reports_ <- getReports(
    projectId = as.integer(distillerProjectId_),
    distillerToken = distillerToken_)
  
  expect_s3_class(reports_, "data.frame")
  expect_equal(ncol(reports_), 4)
})
