#' Get a Distiller report associated to a project of the authenticated user.
#' 
#' This function queries the DistillerSR API to retrieve a saved report
#' associated with a given project ID. It requires user authentication
#' and a valid API endpoint URL. The result is a dataframe containing metadata
#' about the saved report.
#'
#' @param projectId `integer`. The ID of the project as provided by DistillerSR.
#' 
#' @param reportId `integer`. The ID of the report as provided by DistillerSR.
#' 
#' @param format `character` (string). The desired format for the document. It
#'   can be either excel or csv.
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
#' @param attempts `integer`. The maximum number of attempts.
#' 
#'   By default: 1 attempt.
#' 
#' @param retryEach `integer`. The delay between attempts.
#' 
#'   By default: 600 seconds (10 minutes).
#' 
#' @param verbose `logical`. A flag to specify whether to make the function
#'   verbose or not.
#'   
#'   By default: TRUE.
#' 
#' @return A data frame containing the Distiller report as designed within
#'   DistillerSR.
#'
#' @importFrom checkmate assert_int assert_string assert_choice assert_logical
#' @importFrom cli cli_abort
#'
#' @seealso \code{\link{getAuthenticationToken}}
#' @seealso \code{\link{getProjects}}
#' @seealso \code{\link{getReports}}
#'
#' @examplesIf FALSE
#' distillerToken_ <- getAuthenticationToken()
#' projects_ <- getProjects(distillerToken = distillerToken_)
#' reports_ <- getReports(
#'   projectId = projects_$id[1],
#'   distillerToken = distillerToken_)
#'   
#' report_ <- getReport(
#'   projectId = projects_$id[1],
#'   reportID = reports_$id[7],
#'   format = "csv",
#'   distillerToken = distillerToken_)
#' 
#' @export
#' 
getReport <- function(
  projectId,
  reportId,
  format = c("excel", "csv"),
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerToken,
  timeout = 1800,
  attempts = 1,
  retryEach = 600,
  verbose = TRUE) {

  assert_int(projectId)
  assert_int(reportId)
  assert_string(format)
  assert_choice(format, eval(formals()$format))
  assert_string(distillerInstanceUrl, pattern = "[^/]$")
  assert_string(distillerToken)
  assert_int(attempts, lower = 1)
  assert_int(retryEach, lower = 0)
  assert_logical(verbose)
  
  reportUrl_ <- glue("{distillerInstanceUrl}/datarama/query")
  
  request_ <- .buildServiceRequest(
    serviceUrl = reportUrl_,
    distillerToken = distillerToken,
    timeout = timeout,
    body = list(
      "project_id" = projectId,
      "saved_report_id" = reportId,
      "use_saved_format"= TRUE))

  attempt_ <- 0

  while (attempt_ < attempts) {
    attempt_ <- attempt_ + 1
    
    if (verbose && attempts > 1) {
      print(glue("Starting attempt {attempt_}..."))
    }
    
    tryCatch({
      response_ <- .performRequest(
        request = request_,
        errorMessage = glue("Request for report {reportId} failed"))
      
      .handleHTTPErrors(
        response = response_,
        errorMessage = glue("Unable to retrieve report {reportId}"))
      
      if (format == "csv") {
        csvData_ <- .parseCSVResponse(
          response = response_,
          errorMessage = glue("Failed to parse CSV for report {reportId}"))
        return(csvData_)
        
      } else {
        xlsxData_ <- .parseXLSXResponse(
          response = response_,
          errorMessage = glue("Failed to parse XLSX for report {reportId}"))
        return(xlsxData_)
      }
    },
    error = function(e_) {
      if (verbose) {
        print(glue("Attempt failed with reason:\n{e_}"))
      }
      
      if (attempt_ < attempts) {
        if (verbose) {
          print(glue("Sleeping for {retryEach} seconds..."))
        }
        .sleep(retryEach)
      }
    })
  }
  
  cli_abort(c(
    glue("Unable to retrieve report {reportId}"),
    "x" = "All attempts to retrieve the report failed"
  ))
}
