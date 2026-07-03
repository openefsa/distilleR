#' Submit an asynchronous job to retrieve a Distiller report.
#' 
#' This function submits an asynchronous job to DistillerSR to retrieve a saved 
#' report associated with a given project ID. It requires user authentication
#' and a valid asynchronous API endpoint URL. The result is a dataframe
#' containing metadata about the submitted job.
#'
#' @param projectId `integer`. The ID of the project as provided by DistillerSR.
#' 
#' @param reportId `integer`. The ID of the report as provided by DistillerSR.
#' 
#' @param distillerInstanceUrl `character` (string, optional). The Distiller
#'   instance URL.
#' 
#'   By default: Sys.getenv("DISTILLER_INSTANCE_URL").
#' 
#' @param distillerAsyncInstanceUrl `character` (string, optional). The
#'   asynchronous Distiller instance URL.
#' 
#'   By default: Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL").
#' 
#' @param distillerToken `character` (string). The token the user gets once
#'   authenticated.
#' 
#' @param timeout `integer` (optional). The maximum number of seconds to wait
#'   for the response.
#' 
#'   By default: 1800 seconds (30 minutes).
#' 
#' @return A data frame containing metadata about the submitted job.
#'
#' @importFrom checkmate assert_int assert_string
#' @importFrom tibble as_tibble
#'
#' @seealso \code{\link{getAuthenticationToken}}
#' @seealso \code{\link{getProjects}}
#' @seealso \code{\link{getReports}}
#' @seealso \code{\link{getAsyncReportStatus}}
#' @seealso \code{\link{getAsyncReportResult}}
#'
#' @examples
#' \dontrun{
#' distillerToken_ <- getAuthenticationToken()
#' 
#' projects_ <- getProjects(distillerToken = distillerToken_)
#' 
#' reports_ <- getReports(
#'   projectId = projects_$id[1],
#'   distillerToken = distillerToken_)
#'   
#' job_ <- getReportAsync(
#'   projectId = projects_$id[1],
#'   reportID = reports_$id[7],
#'   format = "csv",
#'   distillerToken = distillerToken_)
#' }
#' 
#' @export
#' 
getReportAsync <- function(
  projectId,
  reportId,
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerAsyncInstanceUrl = Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL"),
  distillerToken,
  timeout = 1800) {
  
  assert_int(projectId)
  assert_int(reportId)
  assert_string(distillerInstanceUrl, pattern = "[^/]$")
  assert_string(distillerAsyncInstanceUrl, pattern = "[^/]$")
  assert_string(distillerToken)
  assert_int(timeout)
  
  serviceUrl_ <- glue("{distillerAsyncInstanceUrl}/jobs")
  reportUrl_ <- glue("{distillerInstanceUrl}/datarama/query")
  
  request_ <- .buildServiceRequest(
    serviceUrl = serviceUrl_,
    timeout = timeout,
    body = list(
      "endpoint" = reportUrl_,
      "method" = "POST",
      "headers" = list(
        "Authorization" = glue("Bearer {distillerToken}"),
        "Content-Type" = "application/json"
      ),
      "body" = list(
        "project_id" = glue("{projectId}"),
        "saved_report_id" = glue("{reportId}"),
        "use_saved_format"= "true")
      ))
  
  response_ <- .performRequest(
    request = request_,
    errorMessage = glue("Job submission request for report {reportId} failed"))
  
  .handleHTTPErrors(
    response = response_,
    allowedStatusCode = 202,
    errorMessage = glue("Unable to submit job for report {reportId}"))
  
  responseData_ <- .parseJSONResponse(
    response = response_,
    errorMessage = "Failed to parse job submission response")
  
  responseData_ <- as_tibble(responseData_)
  
  return(responseData_)
}
