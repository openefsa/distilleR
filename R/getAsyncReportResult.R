#' Get the result of an asynchronous job to retrieve a Distiller report.
#' 
#' This function gets the result of a successful Distiller asynchronous job to
#' retrieve a saved report associated with a given project ID. It requires a
#' valid asynchronous job token. The result is a dataframe containing metadata
#' about the saved report.
#'
#' @param jobToken `character` (string). The token associated to the successful
#'   asynchronous job.
#'   
#' @param format `character` (string). The desired format for the document. It
#'   can be either excel or csv.
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
#' @return A data frame containing the Distiller report as designed within
#'   DistillerSR.
#'
#' @importFrom checkmate assert_int assert_string assert_choice
#' @importFrom tibble as_tibble
#'
#' @seealso \code{\link{getAuthenticationToken}}
#' @seealso \code{\link{getProjects}}
#' @seealso \code{\link{getReports}}
#' @seealso \code{\link{getReportAsync}}
#' @seealso \code{\link{getAsyncReportStatus}}
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
#' jobResult_ <- getAsyncReportResult(jobToken = jobToken_, format = "csv")
#' }
#' 
#' @export
#' 
getAsyncReportResult <- function(
  jobToken,
  format = c("excel", "csv"),
  distillerAsyncInstanceUrl = Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL"),
  timeout = 1800) {
  
  assert_string(jobToken)
  assert_string(format)
  assert_choice(format, eval(formals()$format))
  assert_string(distillerAsyncInstanceUrl, pattern = "[^/]$")
  assert_int(timeout)
  
  serviceUrl_ <- glue("{distillerAsyncInstanceUrl}/jobs/{jobToken}/result")
  
  request_ <- .buildServiceRequest(
    serviceUrl = serviceUrl_,
    timeout = timeout)
  
  response_ <- .performRequest(
    request = request_,
    errorMessage = glue("Request for job result failed"))
  
  .handleHTTPErrors(
    response = response_,
    errorMessage = glue("Unable to get job result"))
  
  if (format == "csv") {
    responseData_ <- .parseCSVResponse(
      response = response_,
      errorMessage = glue("Failed to parse the requested report as CSV"))
  } else {
    responseData_ <- .parseXLSXResponse(
      response = response_,
      errorMessage = glue("Failed to parse the requested report as XLSX"))
  }
  
  return(responseData_)
}
