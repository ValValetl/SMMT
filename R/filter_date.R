#' Filter by date
#' 
#' Filter for existing municipalities at a specific point in time.
#'
#' @param tbl A tibble
#' @param date A \code{Date} object of length one.
#' 
#' @return A tibble which is a subset of \code{tbl}
#' 
#' @export

filter_date <- function(tbl, date) {
  
  tbl <- filter(tbl, admission_date <= date & (abolition_date > date | is.na(abolition_date)))
  
  return(tbl)
}
