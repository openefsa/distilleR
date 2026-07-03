test_that("The project ID must be an integer", {
  expect_error(
    getReportAsync(
      projectId = "",
      reportId = 456,
      distillerInstanceUrl = "https://example.org",
      distillerAsyncInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800))
})

test_that("The report ID must be an integer", {
  expect_error(
    getReportAsync(
      projectId = 123,
      reportId = "",
      distillerInstanceUrl = "https://example.org",
      distillerAsyncInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800))
})

test_that("The instance url must be a string", {
  expect_error(
    getReportAsync(
      projectId = 123,
      reportId = 456,
      distillerInstanceUrl = 1,
      distillerAsyncInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800))
})

test_that("The async instance url must be a string", {
  expect_error(
    getReportAsync(
      projectId = 123,
      reportId = 456,
      distillerInstanceUrl = "https://example.org",
      distillerAsyncInstanceUrl = 1,
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800))
})

test_that("The token must be a string", {
  expect_error(
    getReportAsync(
      projectId = 123,
      reportId = 456,
      distillerInstanceUrl = "https://example.org",
      distillerAsyncInstanceUrl = "https://example.org",
      distillerToken = 1,
      timeout = 1800))
})

test_that("The timeout must be an integer", {
  expect_error(
    getReportAsync(
      projectId = 123,
      reportId = 456,
      distillerInstanceUrl = "https://example.org",
      distillerAsyncInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = ""))
})

test_that("Expect an error if a bad async instance URL is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      invalidUrl_ <- "https://invalid_instance/jobs"
      if (request$url == invalidUrl_) { stop() }
    }, {
      expect_error(
        getReportAsync(
          projectId = 123,
          reportId = 456,
          distillerInstanceUrl = "https://example.org",
          distillerAsyncInstanceUrl = "https://invalid_instance",
          distillerToken = "DISTILLER_TOKEN"))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL, DISTILLER_API_KEY,
# DISTILLER_PROJECT_ID_TEST, and DISTILLER_REPORT_ID_TEST environment variables
# to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad async instance URL is specified", {
  skip_on_cran()
  
  distillerAsyncInstanceUrl_ <- "https://invalid_instance"
  distillerProjectId_ <- Sys.getenv("DISTILLER_PROJECT_ID_TEST")
  distillerReportId_ <- Sys.getenv("DISTILLER_REPORT_ID_TEST")
  
  expect_error(
    getReportAsync(
      projectId = as.integer(distillerProjectId_),
      reportId = as.integer(distillerReportId_),
      distillerAsyncInstanceUrl = distillerAsyncInstanceUrl_,
      distillerToken = "DISTILLER_TOKEN"))
})

test_that("A tibble must be returned", {
  response_ <- httr2::response(
    status_code = 202,
    url = "https://example.org/jobs",
    method = "POST",
    headers = list("Content-Type" = "application/json"),
    body = charToRaw("{\"a\": 1, \"b\": 2, \"c\": 3, \"d\": 4}"))
  
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      return(response_)
    }, {
      job_ <- getReportAsync(
        projectId = 123,
        reportId = 456,
        distillerInstanceUrl = "https://example.org",
        distillerAsyncInstanceUrl = "https://example.org",
        distillerToken = "DISTILLER_TOKEN")
      
      expect_s3_class(job_, "data.frame")
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL, DISTILLER_ASYNC_INSTANCE_URL,
# DISTILLER_API_KEY, DISTILLER_PROJECT_ID_TEST, and DISTILLER_REPORT_ID_TEST
# environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("A tibble must be returned", {
  skip_on_cran()
  
  distillerToken_ <- getAuthenticationToken()
  distillerProjectId_ <- Sys.getenv("DISTILLER_PROJECT_ID_TEST")
  distillerReportId_ <- Sys.getenv("DISTILLER_REPORT_ID_TEST")
  
  job_ <- getReportAsync(
    projectId = as.integer(distillerProjectId_),
    reportId = as.integer(distillerReportId_),
    distillerToken = distillerToken_)
  
  expect_s3_class(job_, "data.frame")
})
