test_that("The response parameter must be an httr2_response object", {
  expect_error(
    .parseXLSXResponse(
      response = 123))
})

test_that("The error message parameter must be a string", {
  expect_error(
    .parseXLSXResponse(
      response = httr2::response(),
      errorMessage = 123))
})

test_that("The output must be a dataframe", {
  df_ <- data.frame(a = 1, b = 2, c = 3)
  
  xlsxTempFile_ <- tempfile(fileext = ".xlsx")
  openxlsx::write.xlsx(df_, xlsxTempFile_)
  
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
  
  expect_s3_class(
    .parseXLSXResponse(
      response = response_),
    "data.frame")
})

test_that("Expect an error if the response delivers invalid data", {
  response_ <- httr2::response(
    status_code = 200,
    url = "https://example.org/endpoint",
    method = "POST",
    headers = list(
      "Content-Type" =
        "application/vnd.openxmlformats-officedocuments.spreadsheetml.sheet"),
    body = charToRaw("invalid XLSX data"))
  
  expect_error(
    .parseXLSXResponse(
      response = response_))
})
