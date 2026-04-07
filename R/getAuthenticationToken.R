#' Authenticate to a DistillerSR session.
#'
#' Authenticates a user to a DistillerSR instance using a personal access key.
#' The function returns a valid authentication token that can be used to access
#' protected DistillerSR API endpoints.
#'
#' By default, the personal access key and the instance URL are read from the
#' environment variables `DISTILLER_API_KEY` and `DISTILLER_INSTANCE_URL`.
#' 
#' @param distillerKey `character` (string). The personal access key generated
#'   in DistillerSR.
#' 
#'   By default: Sys.getenv("DISTILLER_API_KEY").
#' 
#' @param distillerInstanceUrl `character` (string). The base URL of the
#'   DistillerSR instance.
#'
#'   By default: Sys.getenv("DISTILLER_INSTANCE_URL").
#'   
#' @param timeout `integer`. The maximum number of seconds to wait for the
#'   authentication response.
#' 
#'   By default: 1800 seconds (30 minutes).
#'
#' @return A string containing a valid DistillerSR authentication token.
#'
#' @importFrom checkmate assert_string assert_int
#'
#' @examplesIf FALSE
#' # If 'DISTILLER_INSTANCE_URL' and 'DISTILLER_API_KEY' are defined in your
#' # environment (e.g. .Renviron).
#' distillerToken_ <- getAuthenticationToken()
#' 
#' # If 'distillerInstanceUrl' and 'distillerKey' are to be specified manually.
#' distillerToken_ <- getAuthenticationToken(
#'   distillerInstanceUrl = "https://url.to.distiller.instance",
#'   distillerKey = "YOUR_API_KEY"
#' )
#' 
#' @export
#' 
getAuthenticationToken <- function(
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerKey = Sys.getenv("DISTILLER_API_KEY"),
  timeout = 1800) {

  assert_string(distillerInstanceUrl, pattern = "[^/]$")
  assert_string(distillerKey)
  assert_int(timeout)
  
  request_ <- .buildAuthenticationRequest(
    distillerInstanceUrl = distillerInstanceUrl,
    distillerKey = distillerKey,
    timeout = timeout)
  
  response_ <- .performRequest(
    request = request_,
    errorMessage = "Authentication request failed")
  
  .handleHTTPErrors(
    response = response_,
    errorMessage = "Authentication failed")
  
  responseData_ <- .parseJSONResponse(
    response = response_,
    errorMessage = "Failed to parse authentication response")

  return(responseData_$token)
}
