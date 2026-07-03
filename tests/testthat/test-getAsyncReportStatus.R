test_that("The job token must be a string", {
  expect_error(
    getAsyncReportStatus(
      jobToken = 1,
      distillerAsyncInstanceUrl = "https://example.org",
      timeout = 1800))
})

test_that("The async instance url must be a string", {
  expect_error(
    getAsyncReportStatus(
      jobToken = "JOB_TOKEN",
      distillerAsyncInstanceUrl = 1,
      timeout = 1800))
})

test_that("The timeout must be an integer", {
  expect_error(
    getAsyncReportStatus(
      jobToken = "JOB_TOKEN",
      distillerAsyncInstanceUrl = "https://example.org",
      timeout = ""))
})

test_that("Expect an error if a bad job token is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      invalidUrl_ <- "https://example.org/jobs/BAD_JOB_TOKEN"
      if (request$url == invalidUrl_) { stop() }
    }, {
      expect_error(
        getAsyncReportStatus(
          jobToken = "BAD_JOB_TOKEN",
          distillerAsyncInstanceUrl = "https://example.org"))
    }
  )
})

# This test requires the DISTILLER_ASYNC_INSTANCE_URL environment variable to
# be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad job token is specified", {
  skip_on_cran()
  
  expect_error(
    getAsyncReportStatus(
      jobToken = "BAD_JOB_TOKEN"))
})

test_that("Expect an error if a bad async instance URL is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      invalidUrl_ <- "https://invalid_instance/jobs/JOB_TOKEN"
      if (request$url == invalidUrl_) { stop() }
    }, {
      expect_error(
        getAsyncReportStatus(
          jobToken = "JOB_TOKEN",
          distillerAsyncInstanceUrl = "https://invalid_instance"))
    }
  )
})

# This test requires the DISTILLER_ASYNC_INSTANCE_URL environment variable to
# be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad async instance URL is specified", {
  skip_on_cran()
  
  expect_error(
    getAsyncReportStatus(
      jobToken = "JOB_TOKEN",
      distillerAsyncInstanceUrl = "https://invalid_instance"))
})

test_that("A tibble must be returned", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/jobs/JOB_TOKEN",
    method = "GET",
    headers = list("Content-Type" = "application/json"),
    body = charToRaw("{\"a\": 1, \"b\": 2, \"c\": 3, \"d\": 4}"))
  
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      return(response_)
    }, {
      jobStatus_ <- getAsyncReportStatus(
        jobToken = "JOB_TOKEN",
        distillerAsyncInstanceUrl = "https://example.org")
      
      expect_s3_class(jobStatus_, "data.frame")
    }
  )
})

# This test requires the DISTILLER_ASYNC_INSTANCE_URL and
# DISTILLER_JOB_TOKEN_XLSX_TEST environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("A tibble must be returned", {
  skip_on_cran()
  
  jobStatus_ <- getAsyncReportStatus(
    jobToken = Sys.getenv("DISTILLER_JOB_TOKEN_XLSX_TEST"))
  
  expect_s3_class(jobStatus_, "data.frame")
})
