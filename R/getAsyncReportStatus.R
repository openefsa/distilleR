#' Get the status of an asynchronous job to retrieve a Distiller report.
#' 
#' This function gets the status of a successfully submitted Distiller
#' asynchronous job to retrieve a saved report associated with a given project
#' ID. It requires a valid asynchronous job token. The result is a dataframe
#' containing metadata about the job status.
#'
#' @param jobToken `character` (string). The token associated to the submitted
#'   asynchronous job.
#' 
#' @param distillerAsyncInstanceUrl `character` (string, optional). The
#'   asynchronous Distiller instance URL.
#' 
#'   By default: Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL").
#' 
#' @param timeout `integer` (optional). The maximum number of seconds to wait
#'   for the response.
#' 
#'   By default: 1800 seconds (30 minutes).
#' 
#' @return A data frame containing metadata about the job status.
#'
#' @importFrom checkmate assert_int assert_string
#' @importFrom purrr map
#' @importFrom tibble as_tibble
#'
#' @seealso \code{\link{getAuthenticationToken}}
#' @seealso \code{\link{getProjects}}
#' @seealso \code{\link{getReports}}
#' @seealso \code{\link{getReportAsync}}
#' @seealso \code{\link{getAsyncReportResult}}
#' 
#' @details
#' After receiving the response and parsing it to JSON, a sanitation step is
#' applied on the data to transform `NULL` values to `NA` characters, in order
#' for tibble's `as_tibble()` to handle them properly.
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
#' 
#' jobToken_ <- job_$token
#' 
#' jobStatus_ <- getAsyncReportStatus(jobToken = jobToken_)
#' }
#' 
#' @export
#' 
getAsyncReportStatus <- function(
  jobToken,
  distillerAsyncInstanceUrl = Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL"),
  timeout = 1800) {
  
  assert_string(jobToken)
  assert_string(distillerAsyncInstanceUrl, pattern = "[^/]$")
  assert_int(timeout)
  
  serviceUrl_ <- glue("{distillerAsyncInstanceUrl}/jobs/{jobToken}")
  
  request_ <- .buildServiceRequest(
    serviceUrl = serviceUrl_,
    timeout = timeout)
  
  response_ <- .performRequest(
    request = request_,
    errorMessage = glue("Request for job status failed"))
  
  .handleHTTPErrors(
    response = response_,
    errorMessage = glue("Unable to get job status"))
  
  responseData_ <- .parseJSONResponse(
    response = response_,
    errorMessage = "Failed to parse job status response")
  
  responseData_ <- map(responseData_,
    ~ if (is.null(.x)) NA_character_ else .x)
  
  responseData_ <- as_tibble(responseData_)
  
  return(responseData_)
}
