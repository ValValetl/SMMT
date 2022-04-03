#' Most recent changes
#' 
#' Returns a table with the most recently changed municipalities.
#' 
#' @param mutations A tibble with municipality mutations (as created by
#'   \code{\link{import_CH_municipality_inventory}})
#'
#' @export
#' 
most_recent_changes <- function(mutations) {
  
  mutations_most_recent <- filter(mutations, change_date == date_of_last_update(mutations))
  
  return(mutations_most_recent)
}
