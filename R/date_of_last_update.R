#' Get date of last municipal inventory update
#'
#' Obtain the most recent change in the municipal inventory database. Most but
#' not all municipal mutations are made at first of january.
#'
#' @param mutations A tibble with municipality mutations (as created by
#'   \code{\link{import_CH_municipality_inventory}})
#'
#' @return A \code{Date} object of length one.
#'
#' @export

date_of_last_update <- function(mutations) {
  return(max(mutations$change_date))
}


