
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Swiss Municipality Data Merger Tool

## Introduction

The SMMT is an R Package which helps merge municipal level data sets
available for different points in time.

If you ever worked with Swiss municipal-level data, you almost certainly
encountered the issue that the municipal state of your dataset is not
the one you desired. E.g. it’s not the actual municpial state or it does
not match the state of a second dataset.

This R package helps to bring the municipal states together.

A good starting point is [this vignette
article](https://smmt.valentinknechtl.ch/articles/manual.html).

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

``` r
# Install most recent version from github.
devtools::install_github("ValValetl/SMMT")
```

## Get started

-   Read the vignette `vignette("manual")` /
    [online](https://smmt.valentinknechtl.ch/articles/manual.html)
-   Look up the documentation of `?map_old_to_new_state`

## Resources

-   SMMT on [CRAN](https://cran.r-project.org/package=SMMT)
-   For more background details, see [this
    article](https://onlinelibrary.wiley.com/doi/full/10.1111/spsr.12487)
    in the Swiss Political Science Review.

## Further documentation

-   [eCH-0071 Datenstandard Historisiertes Gemeindeverzeichnis der
    Schweiz](https://ech.ch/de/standards/60121): The Swiss municipal
    inventory is a well documented data standard which can be consulted
    at this webpage.
