#' Mutation count
#'
#' Count number of mutations in a given time period
#'
#' @inherit map_old_to_new_state
#' @param start_date Date vector (incl)
#' @param end_date Date vector (excluded)
#' @param territorial_changes_only boolean. FALSE if all mutations should be
#'   considered. TRUE if mutations that have an effect on the municipal
#'   territory only should be considered. FALSE includes name changes, Bezirk
#'   number changes etc.
#'
#' @export

mutation_count <- function(mutations, start_date, end_date = Sys.Date(), territorial_changes_only = FALSE) {
  
  
  # Do not count first admission
  mutations <- filter(mutations, admission_nr != 1000)
  
  if (territorial_changes_only)
    mutations <- filter(mutations, admission_mode %in% c(21, 26))
  
  sy <- mutations %>% 
    group_by(canton, admission_date, admission_nr) %>%
    summarise(n_muni = n(), .groups = "drop")
  
  
  
  number_of_mutations_in_period <- numeric()
  
  for (ii in 1:length(start_date)) {
    
    tmp <- filter(sy, admission_date >= start_date[ii] & admission_date < end_date[ii])
    number_of_mutations_in_period[ii] <- nrow(tmp)
    
  }
  
  result <- tibble(start_date, end_date, number_of_mutations_in_period)
  
  return(result)
}
