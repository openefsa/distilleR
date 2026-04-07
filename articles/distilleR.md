# distilleR

## Overview

The **distilleR** package provides a pool of functions to query
**DistillerSR** through its APIs. It features authentication and
utilities to retrieve data from DistillerSR projects and reports.

The package is intended for researchers, analysts, and practitioners who
require convenient programmatic access to DistillerSR data.

## Installation

### From CRAN

``` r
install.packages("distilleR")
```

### Development version (from GitHub)

To install the latest development version:

``` r
# install.packages("devtools")
devtools::install_github("openefsa/distilleR")
```

## Requirements

An active internet connection is required, as the package communicates
with DistillerSR online services to fetch and process data.

## Working with API keys and environment variables

The *distilleR* package requires an authentication token to function
properly. The token can be obtained by authenticating through the
[`getAuthenticationToken()`](https://openefsa.github.io/distilleR/reference/getAuthenticationToken.md)
function. The function needs your personal API key provided by
DistillerSR. You can provide your API key in one of two ways:

1.  By setting it in the `.Renviron` file.  
2.  By including it manually in the authentication request.

### Setting the API key via `.Renviron`

The `.Renviron` file is used to define environment variables that R
loads automatically at the start of each session. This approach is
particularly convenient for sensitive information like API keys, as it
allows you to use them in any R script or function without hardcoding
them.

Place the `.Renviron` file in your home directory (for example,
`C:/Users/username/Documents/.Renviron` on Windows or `~/.Renviron` on
Unix-like systems). You can create or edit this file with any plain text
editor.

Add your DistillerSR API key in the following format:

`DISTILLER_API_KEY=<your_distiller_api_key>`

After saving the file, R will automatically read the API key on startup.

### Setting the API key manually for the authentication request

Alternatively, you can provide the API key directly in the
`distillerKey` argument of the
[`getAuthenticationToken()`](https://openefsa.github.io/distilleR/reference/getAuthenticationToken.md)
function. This is useful if you refer not to store the API key globally.
For example:

``` r
token <- getAuthenticationToken(distillerKey = "<your_distiller_api_key>")
```

### Setting the DistillerSR instance URL

The *distilleR* package needs to know the instance URL on which
DistillerSR is running to function properly. You can provide the
instance URL in one of two ways:

1.  By setting it in the `.Renviron` file.  
2.  By including it manually in each API request.

If you prefer to store the URL in the `.Renviron` file, add your
DistillerSR instance URL in the following format:

`DISTILLER_INSTANCE_URL=<your_distiller_instance_url>`

After saving the file, R will automatically read the API key on startup.

Alternatively, you can provide the instance URL directly in the
`distillerInstanceUrl` argument of functions that require it. This is
useful if you refer not to store the instance URL globally. For example:

``` r
token <- getAuthenticationToken(
  distillerKey = "<your_distiller_api_key>",
  distillerInstanceUrl = "<your_distiller_instance_url>"
)
```

or

``` r
projects <- getProjects(
  token = token,
  distillerInstanceUrl = "<your_distiller_instance_url>"
)
```

## Basic usage

The main purpose of *distilleR* is to query the DistillerSR APIs for
specific project or report codes and retrieve relevant information
across various endpoints.

Below are examples demonstrating how to use the functions in this
package. First, load the *distilleR* package:

``` r
library(distilleR)
```

To explore the arguments and usage of a specific function, you can run:

``` r
help("<function_name>")
```

This will show the full documentation for the function, including its
arguments, return values, and usage examples.

For example, if you are working with the
[`getReport()`](https://openefsa.github.io/distilleR/reference/getReport.md)
function, you can check its documentation with:

``` r
help("getReport")
```

## Getting an authentication token

Before using functions of this package, you must obtain an
authentication token derived from the API key provided by DistillerSR.
To to so, use the
[`getAuthenticationToken()`](https://openefsa.github.io/distilleR/reference/getAuthenticationToken.md)
function:

``` r
token <- getAuthenticationToken()
```

The token can be now used to perform API calls using the
[`getProjects()`](https://openefsa.github.io/distilleR/reference/getProjects.md),
[`getReports()`](https://openefsa.github.io/distilleR/reference/getReports.md),
and
[`getReport()`](https://openefsa.github.io/distilleR/reference/getReport.md)
functions.

## Getting the list of projects associated with the user

If you want to retrieve the list of all the available projects
associated with your DistillerSR account, you can browse them with the
[`getProjects()`](https://openefsa.github.io/distilleR/reference/getProjects.md)
function, as follows:

``` r
projects <- getProjects(distillerToken = token)

print(projects)
```

## Getting the list of reports associated with a project

Each individual project has its own associated set of projects. You can
retrieve the list of associated reports with the
[`getReports()`](https://openefsa.github.io/distilleR/reference/getReports.md)
function, as follows:

``` r
reports <- getReports(projectId = 1234, distillerToken = token)

print(reports)
```

## Getting a specific report

You can retrieve a specific report with the
[`getReport()`](https://openefsa.github.io/distilleR/reference/getReport.md)
function by specifying a project ID and a report ID, as follows:

``` r
projectId_ <- 1234
reportId_ <- 567

report <- getReport(
  projectId = projectId_,
  reportId = reportId_,
  format = "excel",
  distillerToken = token)

print(head(report))
```

Note that for very large reports, CSV files are generally a better
choice. Exporting to Excel may cause issues when tables exceed one
million rows, whereas CSV handles large datasets more reliably.
