# distilleR

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![codecov](https://codecov.io/gh/openefsa/distilleR/branch/main/graph/badge.svg?token=BF95QQPCA1)](https://codecov.io/gh/openefsa/distilleR)

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

## Usage

Once installed, load the package as usual:

``` r
library(distilleR)
```

Basic usage examples and full documentation are available in the package
[guide](https://openefsa.github.io/distilleR/articles/distilleR.html) or
in the package vignettes:

``` r
vignette("distilleR")
```

## Links

- **Source code:** [GitHub –
  openefsa/distilleR](https://github.com/openefsa/distilleR)  
- **Bug reports:** [Issues on
  GitHub](https://github.com/openefsa/distilleR/issues)
- **DistillerSR API Documentation:**
  <https://apidocs.evidencepartners.com/>
