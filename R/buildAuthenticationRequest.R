#' Build an authentication request for the DistillerSR API.
#' 
#' This helper function constructs and configures an authentication request
#' object for the DistillerSR API using the `httr2` package.
#' 
#' @param distillerInstanceUrl `character` (string). The URL of the DistillerSR
#'   instance. It must end without a slash.
#' 
#' @param distillerKey `character` (string). The personal access key generated
#'   in DistillerSR.
#'
#' @param timeout `integer`. The maximum number of seconds to wait for the
#'   authentication response.
#' 
#'   By default: 1800 seconds (30 minutes).
#' 
#' @return An `httr2_request` object representing the configured authentication
#'   request.
#' 
#' @details
#' The function sets the HTTP method to `POST`, sets the timeout, and includes
#' the following headers:
#' \itemize{
#'  \item `Authorization` - the API key used for authentication.
#' }
#' 
#' @importFrom checkmate assert_string assert_int
#' @importFrom httr2 request req_method req_headers req_timeout
#' 
#' @keywords internal
#' @noRd
#' 
.buildAuthenticationRequest <- function(
  distillerInstanceUrl,
  distillerKey,
  timeout = 1800) {
  
  assert_string(distillerInstanceUrl, pattern = "[^/]$")
  assert_string(distillerKey)
  assert_int(timeout)
  
  authenticationUrl_ <- glue("{distillerInstanceUrl}/auth")
  
  request_ <- request(authenticationUrl_) |>
    req_method("POST") |>
    req_headers(
      "Authorization" = paste("Key", distillerKey),
      "Content-Type" = "application/octet-stream"
    ) |>
    req_timeout(timeout)
  
  return(request_)
}
