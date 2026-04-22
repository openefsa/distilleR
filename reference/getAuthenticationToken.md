# Authenticate to a DistillerSR session.

Authenticates a user to a DistillerSR instance using a personal access
key. The function returns a valid authentication token that can be used
to access protected DistillerSR API endpoints.

## Usage

``` r
getAuthenticationToken(
  distillerInstanceUrl = Sys.getenv("DISTILLER_INSTANCE_URL"),
  distillerKey = Sys.getenv("DISTILLER_API_KEY"),
  timeout = 1800
)
```

## Arguments

- distillerInstanceUrl:

  `character` (string). The base URL of the DistillerSR instance.

  By default: Sys.getenv("DISTILLER_INSTANCE_URL").

- distillerKey:

  `character` (string). The personal access key generated in
  DistillerSR.

  By default: Sys.getenv("DISTILLER_API_KEY").

- timeout:

  `integer`. The maximum number of seconds to wait for the
  authentication response.

  By default: 1800 seconds (30 minutes).

## Value

A string containing a valid DistillerSR authentication token.

## Details

By default, the personal access key and the instance URL are read from
the environment variables `DISTILLER_API_KEY` and
`DISTILLER_INSTANCE_URL`.

## Examples

``` r
if (FALSE) { # \dontrun{
# If 'DISTILLER_INSTANCE_URL' and 'DISTILLER_API_KEY' are defined in your
# environment (e.g. .Renviron).
distillerToken_ <- getAuthenticationToken()

# If 'distillerInstanceUrl' and 'distillerKey' are to be specified manually.
distillerToken_ <- getAuthenticationToken(
  distillerInstanceUrl = "https://url.to.distiller.instance",
  distillerKey = "YOUR_API_KEY")
} # }
```
