#' Municipality counter
#'
#' Count the municipalities for a set of dates. Either at the national or
#' cantonal level. See vignette for details.
#'
#' @param mutations A tibble containing the municipality mutations inventory
#'   (see \code{\link{import_CH_municipality_inventory}})
#' @param dates A \link{Date} object vector
#' @param geo_level Either "ch" or "cantons".
#'
#' @return A tibble with the municipality count per date and specified
#'   geography.
#'
#' @export

municipality_counter <- function(mutations, dates, geo_level = "ch") {
  
  mutations_no_lakes <- filter(mutations, !(bfs_nr >= 9000 & bfs_nr < 10000))
  
  if (geo_level == "ch") {
    result <- rep(NA, length(dates))  
    for (ii in 1:length(dates)) {
      result[ii] <- nrow(filter_date(mutations_no_lakes, date = dates[ii]))
    }
    t_result <- tibble(date = dates, n = result)
  } else if (geo_level == "cantons") {
    
    result <- list()
    for (ii in 1:length(dates)) {
      result[[ii]] <- filter_date(mutations_no_lakes, date = dates[ii]) %>% 
        group_by(canton) %>% 
        summarise(n = n()) %>% add_column(date = dates[ii], .before = 1)
    }
    
    t_result <- bind_rows(result)
    
  } else {
    stop("Invalid geo level input")
  }
  return(t_result)
}

