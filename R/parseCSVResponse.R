#' Parse an API CSV response.
#' 
#' This helper function parses the CSV body of an API response.
#' 
#' @param response `httr2_response`. An HTTP response object returned by
#'   `httr2::req_perform()`.
#' 
#' @param errorMessage `character` (string). The message to display in case of
#'   errors.
#' 
#' @param verbose `logical`. A flag to specify whether to make the parsing
#'   verbose or not.
#' 
#'   By default: TRUE.
#' 
#' @return A dataframe containing the parsed CSV response.
#' 
#' @details
#' If the API response body cannot be parsed as valid CSV, the function raises
#' an error, including the original parsing error message.
#' 
#' @importFrom checkmate assert_class assert_string assert_logical
#' @importFrom readr read_csv cols
#' @importFrom httr2 resp_body_string
#' @importFrom cli cli_abort
#'
#' @examplesIf FALSE
#' response_ <- req_perform(request("https://example.org/"))
#' 
#' csvResponseData_ <- .parseCSVResponse(response = response_)
#' 
#' @keywords internal
#' @noRd
#' 
.parseCSVResponse <- function(
  response,
  errorMessage = "Failed to parse API CSV response",
  verbose = TRUE) {
  
  assert_class(response, "httr2_response")
  assert_string(errorMessage)
  assert_logical(verbose)
  
  csvResponseData_ <- tryCatch(
    read_csv(
      resp_body_string(response),
      col_types = cols(.default = "c"),
      show_col_types = verbose),
    
    error = function(e) {
      cli_abort(c(
        errorMessage,
        "x" = conditionMessage(e)
      ))
    }
  )
  
  return(csvResponseData_)
}
