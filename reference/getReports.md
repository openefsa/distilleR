# Get the list of the Distiller reports associated to a project of the authenticated user.

This function queries the DistillerSR API to retrieve the list of saved
reports associated with a given project ID. It requires user
authentication and a valid API endpoint URL. The result is a dataframe
containing metadata about each saved report.

## Usage

``` r
getReports(
  projectId,
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerToken,
  timeout = 1800
)
```

## Arguments

- projectId:

  `integer`. The ID of the project as provided by DistillerSR.

- distillerInstanceUrl:

  `character` (string). The distiller instance URL.

  By default: Sys.getenv("DISTILLER_INSTANCE_URL").

- distillerToken:

  `character` (string). The token the user gets once authenticated.

- timeout:

  `integer`. The maximum number of seconds to wait for the response.

  By default: 1800 seconds (30 minutes).

## Value

A tibble with four columns:

- `id`: The ID of the saved report.

- `name`: The name of the report.

- `date`: The creation date of the report.

- `view`: The format of the report (e.g., html, csv, excel).

## See also

[`getAuthenticationToken`](https://openefsa.github.io/distilleR/reference/getAuthenticationToken.md)

[`getProjects`](https://openefsa.github.io/distilleR/reference/getProjects.md)

## Examples

``` r
if (FALSE) {
distillerToken_ <- getAuthenticationToken()
projects_ <- getProjects(distillerToken = distillerToken_)

reports_ <- getReports(
  projectId = projects_$id[1],
  distillerToken = distillerToken_)
}
```
