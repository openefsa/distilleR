# Get the result of an asynchronous job to retrieve a Distiller report.

This function gets the result of a successful Distiller asynchronous job
to retrieve a saved report associated with a given project ID. It
requires a valid asynchronous job token. The result is a dataframe
containing metadata about the saved report.

## Usage

``` r
getAsyncReportResult(
  jobToken,
  format = c("excel", "csv"),
  distillerAsyncInstanceUrl = Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL"),
  timeout = 1800
)
```

## Arguments

- jobToken:

  `character` (string). The token associated to the successful
  asynchronous job.

- format:

  `character` (string). The desired format for the document. It can be
  either excel or csv.

- distillerAsyncInstanceUrl:

  `character` (string, optional). The asynchronous Distiller instance
  URL.

  By default: Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL").

- timeout:

  `integer` (optional). The maximum number of seconds to wait for the
  response.

  By default: 1800 seconds (30 minutes).

## Value

A data frame containing the Distiller report as designed within
DistillerSR.

## See also

[`getAuthenticationToken`](https://openefsa.github.io/distilleR/reference/getAuthenticationToken.md)

[`getProjects`](https://openefsa.github.io/distilleR/reference/getProjects.md)

[`getReports`](https://openefsa.github.io/distilleR/reference/getReports.md)

[`getReportAsync`](https://openefsa.github.io/distilleR/reference/getReportAsync.md)

[`getAsyncReportStatus`](https://openefsa.github.io/distilleR/reference/getAsyncReportStatus.md)

## Examples

``` r
if (FALSE) { # \dontrun{
distillerToken_ <- getAuthenticationToken()

projects_ <- getProjects(distillerToken = distillerToken_)

reports_ <- getReports(
  projectId = projects_$id[1],
  distillerToken = distillerToken_)
  
job_ <- getReportAsync(
  projectId = projects_$id[1],
  reportID = reports_$id[7],
  format = "csv",
  distillerToken = distillerToken_)

jobToken_ <- job_$token

jobResult_ <- getAsyncReportResult(jobToken = jobToken_, format = "csv")
} # }
```
