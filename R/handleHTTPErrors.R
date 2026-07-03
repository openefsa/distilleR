#' Handle non-successful HTTP responses from the DistillerSR API.
#' 
#' This helper function checks whether an HTTP response from the DistillerSR API
#' indicates success (status code 200). If the response contains any other
#' status code, it raises a formatted error.
#' 
#' @param response `httr2_response`. An object returned by `req_perform()`.
#' 
#' @param allowedStatusCode `integer` (optional). The allowed status code. All
#'   responses with a different status code will raise an error.
#'   
#'   By default: 200.
#' 
#' @param errorMessage `character` (string, optional). The message to display in
#'   case of error.
#' 
#' @return Invisibly returns `NULL` if the response is successful (status code
#'   200). Otherwise, execution stops with a descriptive error message.
#' 
#' @importFrom checkmate assert_class assert_int assert_string
#' @importFrom httr2 resp_status
#' @importFrom cli cli_abort
#' 
#' @keywords internal
#' @noRd
#' 
.handleHTTPErrors <- function(
  response,
  allowedStatusCode = 200,
  errorMessage = "API request failed") {
  
  assert_class(response, "httr2_response")
  assert_int(allowedStatusCode)
  assert_string(errorMessage)
  
  status_ <- resp_status(response)
  
  if (status_ != allowedStatusCode) {
    cli_abort(c(
      errorMessage,
      "x" = "(HTTP {status_})"
    ))
  }
}
