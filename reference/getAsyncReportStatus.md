# Get the status of an asynchronous job to retrieve a Distiller report.

This function gets the status of a successfully submitted Distiller
asynchronous job to retrieve a saved report associated with a given
project ID. It requires a valid asynchronous job token. The result is a
dataframe containing metadata about the job status.

## Usage

``` r
getAsyncReportStatus(
  jobToken,
  distillerAsyncInstanceUrl = Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL"),
  timeout = 1800
)
```

## Arguments

- jobToken:

  `character` (string). The token associated to the submitted
  asynchronous job.

- distillerAsyncInstanceUrl:

  `character` (string, optional). The asynchronous Distiller instance
  URL.

  By default: Sys.getenv("DISTILLER_ASYNC_INSTANCE_URL").

- timeout:

  `integer` (optional). The maximum number of seconds to wait for the
  response.

  By default: 1800 seconds (30 minutes).

## Value

A data frame containing metadata about the job status.

## Details

After receiving the response and parsing it to JSON, a sanitation step
is applied on the data to transform `NULL` values to `NA` characters, in
order for tibble's `as_tibble()` to handle them properly.

## See also

[`getAuthenticationToken`](https://openefsa.github.io/distilleR/reference/getAuthenticationToken.md)

[`getProjects`](https://openefsa.github.io/distilleR/reference/getProjects.md)

[`getReports`](https://openefsa.github.io/distilleR/reference/getReports.md)

[`getReportAsync`](https://openefsa.github.io/distilleR/reference/getReportAsync.md)

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

jobToken_ <- job_$token

jobStatus_ <- getAsyncReportStatus(jobToken = jobToken_)
} # }
```
