#' Municipality counter
#'
#' Count the municipalities for a set of dates. Either at the national or
#' cantonal level.  See vignette for details.
#'
#' @param mutations A tibble containing the municipality mutations inventory
#'   (see \code{\link{import_CH_municipality_inventory}})
#' @param dates A \link{Date} object vector
#' @param geo_level Either "ch" or "cantons".
#' @param include_cant_lakes Boolean, TRUE to also include lakes in the count.
#'
#' @return A tibble with the municipality count per date and specified
#'   geography.
#'
#' @note All entities that have a bfs nr are counted (e.g. also Gemeindefreie
#'   Gebiete). This is not exactly what the BfS does in the webtool Applikation
#'   der Schweizer Gemeinden.  However, it is not possible to distinguish
#'   "Gemeinden" und "Gemeindefreie Gebiete" generically, based on the
#'   information in the Gemeindeverzeichnis.
#'
#' @export

municipality_counter <- function(mutations, dates, geo_level = "ch", include_cant_lakes = FALSE) {
  
  if (!include_cant_lakes) {
    mutations <- filter(mutations, !(bfs_nr >= 9000 & bfs_nr < 10000))
  }
  
  if (geo_level == "ch") {
    result <- rep(NA, length(dates))  
    for (ii in 1:length(dates)) {
      result[ii] <- nrow(filter_date(mutations, date = dates[ii]))
    }
    t_result <- tibble(date = dates, n = result)
  } else if (geo_level == "cantons") {
    
    result <- list()
    for (ii in 1:length(dates)) {
      result[[ii]] <- filter_date(mutations, date = dates[ii]) %>% 
        group_by(canton) %>% 
        summarise(n = n()) %>% add_column(date = dates[ii], .before = 1)
    }
    
    t_result <- bind_rows(result)
    
  } else {
    stop("Invalid geo level input")
  }
  return(t_result)
}

