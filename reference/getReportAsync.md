# Submit an asynchronous job to retrieve a Distiller report.

This function submits an asynchronous job to DistillerSR to retrieve a
saved report associated with a given project ID. It requires user
authentication and a valid asynchronous API endpoint URL. The result is
a dataframe containing metadata about the submitted job.

## Usage

``` r
getReportAsync(
  projectId,
  reportId,
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerAsyncInstanceUrl = Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL"),
  distillerToken,
  timeout = 1800
)
```

## Arguments

- projectId:

  `integer`. The ID of the project as provided by DistillerSR.

- reportId:

  `integer`. The ID of the report as provided by DistillerSR.

- distillerInstanceUrl:

  `character` (string, optional). The Distiller instance URL.

  By default: Sys.getenv("DISTILLER_INSTANCE_URL").

- distillerAsyncInstanceUrl:

  `character` (string, optional). The asynchronous Distiller instance
  URL.

  By default: Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL").

- distillerToken:

  `character` (string). The token the user gets once authenticated.

- timeout:

  `integer` (optional). The maximum number of seconds to wait for the
  response.

  By default: 1800 seconds (30 minutes).

## Value

A data frame containing metadata about the submitted job.

## See also

[`getAuthenticationToken`](https://openefsa.github.io/distilleR/reference/getAuthenticationToken.md)

[`getProjects`](https://openefsa.github.io/distilleR/reference/getProjects.md)

[`getReports`](https://openefsa.github.io/distilleR/reference/getReports.md)

[`getAsyncReportStatus`](https://openefsa.github.io/distilleR/reference/getAsyncReportStatus.md)

[`getAsyncReportResult`](https://openefsa.github.io/distilleR/reference/getAsyncReportResult.md)

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
} # }
```
