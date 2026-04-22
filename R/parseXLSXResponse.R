#' Parse an API XLSX response.
#' 
#' This helper function parses the XLSX body of an API response.
#' 
#' @param response `httr2_response`. An HTTP response object returned by
#'   `httr2::req_perform()`.
#' 
#' @param errorMessage `character` (string). The message to display in case of
#'   errors.
#' 
#' @return A dataframe containing the parsed XLSX response.
#' 
#' @details
#' If the API response body cannot be parsed as valid XLSX, the function raises
#' an error, including the original parsing error message.
#' 
#' @importFrom checkmate assert_class assert_string
#' @importFrom readxl read_excel
#' @importFrom httr2 resp_body_raw
#' @importFrom cli cli_abort
#' 
#' @keywords internal
#' @noRd
#' 
.parseXLSXResponse <- function(
  response,
  errorMessage = "Failed to parse API XLSX response") {
  
  assert_class(response, "httr2_response")
  assert_string(errorMessage)
  
  xlsxResponseData_ <- tryCatch(
    {
      xlsxTempFile_ <- tempfile(fileext = ".xlsx")
      writeBin(resp_body_raw(response), xlsxTempFile_)
      read_excel(xlsxTempFile_, col_types = "text")
    },
    error = function(e) {
      cli_abort(c(
        errorMessage,
        "x" = conditionMessage(e)
      ))
    }
  )
  
  return(xlsxResponseData_)
}
