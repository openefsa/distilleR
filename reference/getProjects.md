# Get the list of the Distiller projects associated to the authenticated user.

This function queries the DistillerSR API to retrieve the list of
projects accessible to the authenticated user. It requires an
authentication token and a valid API instance URL. The result is a
dataframe listing available projects.

## Usage

``` r
getProjects(
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerToken,
  timeout = 1800
)
```

## Arguments

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

- `id`: The project ID.

- `name`: The name of the project.

- `de_project_id`.

- `is_hidden`.

## See also

[`getAuthenticationToken`](https://openefsa.github.io/distilleR/reference/getAuthenticationToken.md)

## Examples

``` r
if (FALSE) {
distillerToken_ <- getAuthenticationToken()

projects_ <- getProjects(distillerToken = distillerToken_)
}
```
