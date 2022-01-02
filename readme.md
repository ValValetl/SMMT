
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Swiss Municipality Data Merger Tool

## Introduction

R Package which helps merge municipal level data sets available for
different points in time.

In Switzerland, the landscape of municipalities is changing rapidly
mainly due to mergers.

-   Number of municipalities in 2000: 2’899
-   Number of municipalities in 2021: 2’163

The Swiss Municipal Data Merger Tool automatically detects these
mutations and maps municipalities over time, i.e. municipalities of an
old state to municipalities of a new state. This functionality is
helpful when working with datasets that are based on different spatial
references like for example Swiss voting data.

## Installation

``` r
# Install released version from CRAN
install.packages("SMMT")
```

## Get started

-   Read the vignette `vignette("SMMT")`
-   Look up the documentation of `?map_old_to_new_state`

## Resources

-   Obtain the latest offical release from
    [CRAN](https://cran.r-project.org/package=SMMT)
-   For more details, see [this
    article](https://onlinelibrary.wiley.com/doi/full/10.1111/spsr.12487)
    in the Swiss Political Science Review.
