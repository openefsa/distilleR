#' Get the list of the Distiller reports associated to a project of the
#' authenticated user.
#' 
#' This function queries the DistillerSR API to retrieve the list of saved
#' reports associated with a given project ID. It requires user authentication
#' and a valid API endpoint URL. The result is a dataframe containing metadata
#' about each saved report.
#'
#' @param projectId `integer`. The ID of the project as provided by DistillerSR.
#' 
#' @param distillerInstanceUrl `character` (string). The distiller instance URL.
#' 
#'   By default: Sys.getenv("DISTILLER_INSTANCE_URL").
#' 
#' @param distillerToken `character` (string). The token the user gets once
#'   authenticated.
#' 
#' @param timeout `integer`. The maximum number of seconds to wait for the
#'   response.
#' 
#'   By default: 1800 seconds (30 minutes).
#' 
#' @return A tibble with four columns:
#' \itemize{
#'   \item \code{id}: The ID of the saved report.
#'   \item \code{name}: The name of the report.
#'   \item \code{date}: The creation date of the report.
#'   \item \code{view}: The format of the report (e.g., html, csv, excel).
#' }
#' 
#' @importFrom checkmate assert_int assert_string
#' @importFrom glue glue
#'
#' @seealso \code{\link{getAuthenticationToken}}
#' @seealso \code{\link{getProjects}}
#' 
#' @examplesIf FALSE
#' distillerToken_ <- getAuthenticationToken()
#' projects_ <- getProjects(distillerToken = distillerToken_)
#' 
#' reports_ <- getReports(
#'   projectId = projects_$id[1],
#'   distillerToken = distillerToken_)
#' 
#' @export
#' 
getReports <- function(
  projectId,
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerToken,
  timeout = 1800) {
  
  assert_int(projectId)
  assert_string(distillerInstanceUrl, pattern = "[^/]$")
  assert_string(distillerToken)
  assert_int(timeout)
  
  reportsUrl_ <- distillerInstanceUrl
  reportsUrl_ <- glue("{reportsUrl_}/projects/{projectId}/reports/datarama")
  
  request_ <- .buildServiceRequest(
    serviceUrl = reportsUrl_,
    distillerToken = distillerToken,
    timeout = timeout)
  
  response_ <- .performRequest(
    request = request_,
    errorMessage = glue("Request for project {projectId} reports failed"))
  
  .handleHTTPErrors(
    response = response_,
    errorMessage = glue("Unable to retrieve reports for project {projectId}"))
  
  responseData_ <- .parseJSONResponse(
    response = response_,
    errorMessage = "Failed to parse reports service response")
  
  responseData_ <- as_tibble(responseData_)
  
  return(responseData_)
}
