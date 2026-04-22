#' Get the list of the Distiller projects associated to the authenticated user.
#' 
#' This function queries the DistillerSR API to retrieve the list of projects
#' accessible to the authenticated user. It requires an authentication token
#' and a valid API instance URL. The result is a dataframe listing available
#' projects.
#' 
#' @param distillerToken `character` (string). The token the user gets once
#'   authenticated.
#' 
#' @param distillerInstanceUrl `character` (string). The distiller instance URL.
#' 
#'   By default: Sys.getenv("DISTILLER_INSTANCE_URL").
#' 
#' @param timeout `integer`. The maximum number of seconds to wait for the
#'   response.
#' 
#'   By default: 1800 seconds (30 minutes).
#' 
#' @return A tibble with four columns:
#' \itemize{
#'   \item \code{id}: The project ID.
#'   \item \code{name}: The name of the project.
#'   \item \code{de_project_id}.
#'   \item \code{is_hidden}.
#' }
#'
#' @importFrom checkmate assert_string assert_int
#' @importFrom tibble as_tibble
#'
#' @seealso \code{\link{getAuthenticationToken}}
#'
#' @examples
#' \dontrun{
#' distillerToken_ <- getAuthenticationToken()
#' 
#' projects_ <- getProjects(distillerToken = distillerToken_)
#' }
#' 
#' @export
#' 
getProjects <- function(
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerToken,
  timeout = 1800) {

  assert_string(distillerInstanceUrl, pattern = "[^/]$")
  assert_string(distillerToken)
  assert_int(timeout)
  
  projectsUrl_ <- glue("{distillerInstanceUrl}/projects")
  
  request_ <- .buildServiceRequest(
    serviceUrl = projectsUrl_,
    distillerToken = distillerToken,
    timeout = timeout)
  
  response_ <- .performRequest(
    request = request_,
    errorMessage = "Request for projects failed")
  
  .handleHTTPErrors(
    response = response_,
    errorMessage = "Unable to retrieve projects")
  
  responseData_ <- .parseJSONResponse(
    response = response_,
    errorMessage = "Failed to parse projects service response")
  
  responseData_ <- as_tibble(responseData_)
  
  return(responseData_)
}
