test_that("The project ID must be an integer", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 1,
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The project ID must be an integer", {
  expect_error(
    getReport(
      projectId = "",
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 1,
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The report ID must be an integer", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = "",
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 1,
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The format must be a string", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = 1,
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 1,
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The format must be allowed", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "json",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 1,
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The url must be a string", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = 1,
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 1,
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The token must be a string", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = 1,
      timeout = 1800,
      attempts = 1,
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The timeout must be an integer", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = "",
      attempts = 1,
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The number of attempts must be an integer", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = "",
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The retry delay must be an integer", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 1,
      retryEach = "",
      verbose = FALSE))
})

test_that("The verbose flag must be a logical", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 1,
      retryEach = 3600,
      verbose = 123))
})

test_that("The attempts must be at least one", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 0,
      retryEach = 3600,
      verbose = FALSE))
})

test_that("The retry delay must be at least the timeout value", {
  expect_error(
    getReport(
      projectId = 123,
      reportId = 456,
      format = "csv",
      distillerInstanceUrl = "https://example.org",
      distillerToken = "DISTILLER_TOKEN",
      timeout = 1800,
      attempts = 1,
      retryEach = 1700,
      verbose = FALSE))
})

test_that("Expect an error if a bad instance URL is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      invalidUrl_ <- "https://invalid_instance/datarama/query"
      if (request$url == invalidUrl_) { stop() }
    }, {
      expect_error(
        getReport(
          projectId = 123,
          reportId = 456,
          format = "excel",
          distillerInstanceUrl = "https://invalid_instance",
          distillerToken = "DISTILLER_TOKEN",
          retryEach = 1,
          verbose = FALSE))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL, DISTILLER_API_KEY,
# DISTILLER_PROJECT_ID_TEST, and DISTILLER_REPORT_ID_TEST environment variables
# to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad instance URL is specified", {
  skip_on_cran()
  
  distillerInstanceUrl_ <- "https://invalid_instance"
  distillerToken_ <- getAuthenticationToken()
  distillerProjectId_ <- Sys.getenv("DISTILLER_PROJECT_ID_TEST")
  distillerReportId_ <- Sys.getenv("DISTILLER_REPORT_ID_TEST")
  
  expect_error(
    getReport(
      projectId = as.integer(distillerProjectId_),
      reportId = as.integer(distillerReportId_),
      format = "excel",
      distillerInstanceUrl = distillerInstanceUrl_,
      distillerToken = "DISTILLER_TOKEN",
      attempts = 1,
      verbose = FALSE))
})

test_that("Expect an error if a bad token is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      authorization_ <- rlang::wref_value(request$headers$Authorization)
      if (authorization_ == "Bearer BAD_TOKEN") { stop() }
    }, {
      expect_error(
        getReport(
          projectId = 123,
          reportId = 456,
          format = "excel",
          distillerInstanceUrl = "https://example.org",
          distillerToken = "BAD_TOKEN",
          attempts = 1,
          verbose = FALSE))
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL, DISTILLER_PROJECT_ID_TEST, 
# DISTILLER_REPORT_ID_TEST and environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("Expect an error if a bad token is specified", {
  skip_on_cran()
  
  distillerProjectId_ <- Sys.getenv("DISTILLER_PROJECT_ID_TEST")
  distillerReportId_ <- Sys.getenv("DISTILLER_REPORT_ID_TEST")
  
  expect_error(
    getReport(
      projectId = as.integer(distillerProjectId_),
      reportId = as.integer(distillerReportId_),
      format = "excel",
      distillerToken = "BAD_TOKEN",
      attempts = 1,
      verbose = FALSE))
})

test_that("A tibble must be returned (XLSX)", {
  dataframe_ <- data.frame(a = 1, b = 2, c = 3)
  
  xlsxTempFile_ <- tempfile(fileext = ".xlsx")
  openxlsx::write.xlsx(dataframe_, xlsxTempFile_)
  
  bodyRaw_ <- readBin(
    xlsxTempFile_,
    what = "raw",
    n = file.info(xlsxTempFile_)$size)
  
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/endpoint",
    method = "POST",
    headers = list(
      "Content-Type" =
        "application/vnd.openxmlformats-officedocuments.spreadsheetml.sheet"),
    body = bodyRaw_)
  
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      return(response_)
    }, {
      reports_ <- getReport(
        projectId = 123,
        reportId = 456,
        format = "excel",
        distillerInstanceUrl = "https://example.org",
        distillerToken = "DISTILLER_TOKEN",
        attempts = 1,
        verbose = FALSE)
      
      expect_s3_class(reports_, "data.frame")
    }
  )
})

# This test requires the DISTILLER_INSTANCE_URL, DISTILLER_API_KEY,
# DISTILLER_PROJECT_ID_TEST, and DISTILLER_REPORT_ID_TEST environment variables
# to be set.
# This test performs real requests to the DistillerSR API.
test_that("A tibble must be returned (XLSX)", {
  skip_on_cran()
  
  distillerToken_ <- getAuthenticationToken()
  distillerProjectId_ <- Sys.getenv("DISTILLER_PROJECT_ID_TEST")
  distillerReportId_ <- Sys.getenv("DISTILLER_REPORT_ID_TEST")
  
  reports_ <- getReport(
    projectId = as.integer(distillerProjectId_),
    reportId = as.integer(distillerReportId_),
    format = "excel",
    distillerToken = distillerToken_,
    attempts = 1,
    verbose = FALSE)
  
  expect_s3_class(reports_, "data.frame")
})

test_that("A tibble must be returned (CSV)", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/endpoint",
    method = "POST",
    headers = list("Content-Type" = "text/csv"),
    body = charToRaw("a,b,c\n1,2,3"))
  
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      return(response_)
    },
    read_csv = function(file, col_types, show_col_types) {
      readr::read_csv(file, col_types = col_types, show_col_types = FALSE)
    }, {
      reports_ <- getReport(
        projectId = 123,
        reportId = 456,
        format = "csv",
        distillerInstanceUrl = "https://example.org",
        distillerToken = "DISTILLER_TOKEN",
        attempts = 1,
        verbose = FALSE)
      
      expect_s3_class(reports_, "data.frame")
    }
  )
})

test_that("The delay mechanism must work properly", {
  sleepCalled_ <- FALSE
  
  with_mocked_bindings(
    .performRequest = function(...) { stop() },
    .sleep = function(seconds) {
      sleepCalled_ <<- TRUE
    }, {
      expect_error(
        getReport(
          projectId = 123,
          reportId = 456,
          format = "csv",
          distillerInstanceUrl = "https://example.org",
          distillerToken = "DISTILLER_TOKEN",
          attempts = 2,
          retryEach = 1,
          verbose = FALSE))
      
      expect_true(sleepCalled_)
    }
  )
})

test_that("The verbosity must work properly", {
  with_mocked_bindings(
    .performRequest = function(...) { stop() },
    {
      expect_error(
        getReport(
          projectId = 123,
          reportId = 456,
          format = "csv",
          distillerInstanceUrl = "https://example.org",
          distillerToken = "DISTILLER_TOKEN",
          attempts = 2,
          retryEach = 1))
    }
  )
})
