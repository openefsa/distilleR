test_that("The job token must be a string", {
  expect_error(
    getAsyncReportResult(
      jobToken = 1,
      format = "csv",
      distillerAsyncInstanceUrl = "https://example.org",
      timeout = 1800))
})

test_that("The format must be a string", {
  expect_error(
    getAsyncReportResult(
      jobToken = "JOB_TOKEN",
      format = 1,
      distillerAsyncInstanceUrl = "https://example.org",
      timeout = 1800))
})

test_that("The format must be allowed", {
  expect_error(
    getAsyncReportResult(
      jobToken = "JOB_TOKEN",
      format = "html",
      distillerAsyncInstanceUrl = "https://example.org",
      timeout = 1800))
})

test_that("The async instance url must be a string", {
  expect_error(
    getAsyncReportResult(
      jobToken = "JOB_TOKEN",
      format = "csv",
      distillerAsyncInstanceUrl = 1,
      timeout = 1800))
})

test_that("The timeout must be an integer", {
  expect_error(
    getAsyncReportResult(
      jobToken = "JOB_TOKEN",
      format = "csv",
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
        getAsyncReportResult(
          jobToken = "BAD_JOB_TOKEN",
          format = "csv",
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
    getAsyncReportResult(
      jobToken = "BAD_JOB_TOKEN",
      format = "csv"))
})

test_that("Expect an error if a bad async instance URL is specified", {
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      invalidUrl_ <- "https://invalid_instance/jobs/JOB_TOKEN/result"
      if (request$url == invalidUrl_) { stop() }
    }, {
      expect_error(
        getAsyncReportResult(
          jobToken = "JOB_TOKEN",
          format = "csv",
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
    getAsyncReportResult(
      jobToken = "JOB_TOKEN",
      distillerAsyncInstanceUrl = "https://invalid_instance"))
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
    url = "https://example.org/jobs/JOB_TOKEN/result",
    method = "GET",
    headers = list(
      "Content-Type" =
        "application/vnd.openxmlformats-officedocuments.spreadsheetml.sheet"),
    body = bodyRaw_)
  
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      return(response_)
    }, {
      report_ <- getAsyncReportResult(
        jobToken = "JOB_TOKEN",
        format = "excel",
        distillerAsyncInstanceUrl = "https://example.org")
      
      expect_s3_class(report_, "data.frame")
    }
  )
})

# This test requires the DISTILLER_ASYNC_INSTANCE_URL and
# DISTILLER_JOB_TOKEN_XLSX_TEST environment variables to be set.
# This test performs real requests to the DistillerSR API.
test_that("A tibble must be returned (XLSX)", {
  skip_on_cran()
  
  report_ <- getAsyncReportResult(
    jobToken = Sys.getenv("DISTILLER_JOB_TOKEN_XLSX_TEST"),
    format = "excel")
  
  expect_s3_class(report_, "data.frame")
})

test_that("A tibble must be returned (CSV)", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/jobs/JOB_TOKEN/result",
    method = "GET",
    headers = list("Content-Type" = "text/csv"),
    body = charToRaw("a,b,c\n1,2,3"))
  
  with_mocked_bindings(
    .performRequest = function(request, errorMessage) {
      return(response_)
    },
    read_csv = function(file, col_types, show_col_types) {
      readr::read_csv(file, col_types = col_types, show_col_types = FALSE)
    }, {
      report_ <- getAsyncReportResult(
        jobToken = "JOB_TOKEN",
        format = "csv",
        distillerAsyncInstanceUrl = "https://example.org")
      
      expect_s3_class(report_, "data.frame")
    }
  )
})

