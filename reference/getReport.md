# Get a Distiller report associated to a project of the authenticated user.

This function queries the DistillerSR API to retrieve a saved report
associated with a given project ID. It requires user authentication and
a valid API endpoint URL. The result is a dataframe containing metadata
about the saved report.

## Usage

``` r
getReport(
  projectId,
  reportId,
  format = c("excel", "csv"),
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerToken,
  timeout = 1800,
  attempts = 1,
  retryEach = 600,
  verbose = TRUE
)
```

## Arguments

- projectId:

  `integer`. The ID of the project as provided by DistillerSR.

- reportId:

  `integer`. The ID of the report as provided by DistillerSR.

- format:

  `character` (string). The desired format for the document. It can be
  either excel or csv.

- distillerInstanceUrl:

  `character` (string). The distiller instance URL.

  By default: Sys.getenv("DISTILLER_INSTANCE_URL").

- distillerToken:

  `character` (string). The token the user gets once authenticated.

- timeout:

  `integer`. The maximum number of seconds to wait for the response.

  By default: 1800 seconds (30 minutes).

- attempts:

  `integer`. The maximum number of attempts.

  By default: 1 attempt.

- retryEach:

  `integer`. The delay between attempts.

  By default: 600 seconds (10 minutes).

- verbose:

  `logical`. A flag to specify whether to make the function verbose or
  not.

  By default: TRUE.

## Value

A data frame containing the Distiller report as designed within
DistillerSR.

## See also

[`getAuthenticationToken`](https://openefsa.github.io/distilleR/reference/getAuthenticationToken.md)

[`getProjects`](https://openefsa.github.io/distilleR/reference/getProjects.md)

[`getReports`](https://openefsa.github.io/distilleR/reference/getReports.md)

## Examples

``` r
if (FALSE) {
distillerToken_ <- getAuthenticationToken()
projects_ <- getProjects(distillerToken = distillerToken_)
reports_ <- getReports(
  projectId = projects_$id[1],
  distillerToken = distillerToken_)
  
report_ <- getReport(
  projectId = projects_$id[1],
  reportID = reports_$id[7],
  format = "csv",
  distillerToken = distillerToken_)
}
```
