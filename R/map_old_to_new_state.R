#' Map municipalities of old state to municipalities of new state
#'
#' This function maps the Swiss municipalities of an old state to municipalities
#' of a new state.
#' 
#' \strong{Approach}
#' 
#' \enumerate{
#' \item Download the \href{https://www.bfs.admin.ch/bfsstatic/dam/assets/11467405/master}{Swiss municipality inventory}
#' \item Import it into R workspace with \code{\link{import_CH_municipality_inventory}}
#' \item Set the old state and the new state (see example)
#' \item Get the mapping table with this function
#' }
#'
#' \strong{Example Daettwil / Baden}
#'
#' On 1.1.1962 Daettwil (Bfs Nr. 4025) merged with Baden (Bfs Nr. 4021). 
#' Let's define \itemize{ \item old_state <- as.Date("1961-01-01") \item
#' new_state <- as.Date("1963-01-01") \item Result: \tabular{rrrrrr}{
#' bfs_nr_new \tab name_new \tab bfs_nr_old \tab name_old \cr 4021 \tab Baden \tab 4021 \tab Baden \cr 4021 \tab Baden \tab
#' 4025 \tab Daettwil } }
#'
#'
#' @param mutations A tibble containing the municipality mutations inventory (see
#'   \code{\link{import_CH_municipality_inventory}})
#' @param state_old A \link{Date} object vector of length one containing the date of
#'   the old state.
#' @param state_new A \link{Date} object vector of length one containing the date of
#'   the new state.
#'
#' @return A list with 4 elements:
#' \enumerate{
#' \item mapped: A tibble with the mapped municipalities
#' \item unmapped: A tibble with the unmapped municipalities
#' \item state_old: see above
#' \item state_new: see above
#' }
#'
#' @examples
#'
#' mutations <- structure(list(hist_id = c(11227L, 11240L, 13189L),
#' district_hist_id = c(10025L, 10025L, 10025L),
#' kanton_abbr = c("AG", "AG", "AG"),
#' bfs_nr = c(4025L, 4021L, 4021L),
#' name = c("Daettwil", "Baden", "Baden"),
#' admission_nr = c(1000L, 1000L, 1004L),
#' admission_mode = c(20L, 20L, 26L),
#' admission_date = structure(c(-3653, -3653, -2922),
#' class = c("Date")),
#' abolition_nr = c(1004L, 1004L, NA),
#' abolition_mode = c(29L, 26L, NA),
#' abolition_date = structure(c(-3653, -3653, NA),
#' class = c("Date")),
#' change_date = structure(c(-3653, -3653, -2922), class = c("Date"))),
#' row.names = c(NA, -3L), class = c("tbl_df", "tbl", "data.frame"))
#'
#' mapping_object <- map_old_to_new_state(mutations,
#' as.Date("1961-01-01"), as.Date("1963-01-01"))
#'
#' @export
#' 

map_old_to_new_state <- function(mutations, state_old, state_new) {
  
  if (state_old >= state_new) {
    stop("New state needs to be bigger than old state")
  }
  
  # Mutation inventory (Search from beginning of DB to "state_new") -------------------
  
  mutations_before_new_state <- filter(mutations, admission_date <= state_new)
  
  bundle_list    <- list()
  bundle_counter <- 1
  for (mutation_ii in 1:nrow(mutations_before_new_state)) {
    
    mutation_entry <- mutations_before_new_state[mutation_ii, ]
    hist_id_list   <- list()
    
    if (nrow(filter_date(mutation_entry, state_new)) > 0) {
      
      hist_id_list[[1]] <- mutation_entry$hist_id
      
      mutation_entry <- filter(mutations_before_new_state, abolition_nr %in% mutation_entry$admission_nr)
      
      
      # Set counter
      counter <- 2
      while (nrow(mutation_entry) > 0) {
        hist_id_list[[counter]] <- mutation_entry$hist_id
        mutation_entry <- filter(mutations_before_new_state, abolition_nr %in% mutation_entry$admission_nr)
        counter <- counter + 1
      }
      
      bundle_list[[bundle_counter]] <- tibble(bundle_id = bundle_counter,
                                              hist_id   = unlist(hist_id_list))
      bundle_counter <- bundle_counter + 1
    }
  }
  
  history <- do.call(rbind, bundle_list)
  
  # Mapping ---------------------------------------------------------------
  # Welche Gemeinden im State OLD gehören zur Gemeinde X im State NEW?
  
  gemeinden_new_state <- filter_date(mutations, state_new)
  
  # Get irreversible mutations
  mutations_irreversible <- get_irreversible_municipality_mutations(mutations = mutations)
  
  mapped_list       <- list()
  non_mapped_list   <- list()
  
  for (row_ii in 1:nrow(gemeinden_new_state)) {
    
    gemeinde_x <- gemeinden_new_state[row_ii, ]
    
    bundle_id_         <- filter(history, hist_id   == gemeinde_x$hist_id)$bundle_id
    hist_ids_of_bundle <- filter(history, bundle_id == bundle_id_)$hist_id
    
    gemeinde_x_history <- filter(mutations, hist_id %in% hist_ids_of_bundle)
    
    irrev_subset <- semi_join(mutations_irreversible, gemeinde_x_history, by = "hist_id")
    
    irreversibility <- FALSE
    if (nrow(irrev_subset) > 0) {
      
      irrev_subset <- filter(irrev_subset, state == "admission")
      irreversibility <- irrev_subset$admission_date > state_old & irrev_subset$admission_date < state_new
      
    }
    
    if (any(irreversibility)) {
      entries_state_old <- filter_date(gemeinde_x_history, state_old)
      
      non_mapped_list[[row_ii]] <- tibble(bfs_nr_new = gemeinde_x$bfs_nr,
                                          name_new   = gemeinde_x$name,
                                          bfs_nr_old = entries_state_old$bfs_nr,
                                          name_old   = entries_state_old$name)
      # No mapping, if irreversible
      mapped_list[[row_ii]] <- tibble(bfs_nr_new    = gemeinde_x$bfs_nr,
                                      name_new      = gemeinde_x$name,
                                      bfs_nr_old    = NA,
                                      name_old      = NA)
    } else {
      # Do mapping, if reversible
      entries_state_old <- filter_date(gemeinde_x_history, state_old)
      
      # Empty element: Required to get an empty tibble in the case when all
      # municipalities can be mapped
      non_mapped_list[[row_ii]] <- tibble(bfs_nr_new = numeric(),
                                          name_new   = character(),
                                          bfs_nr_old = numeric(),
                                          name_old   = character())
      
      mapped_list[[row_ii]] <- tibble(bfs_nr_new = gemeinde_x$bfs_nr,
                                      name_new   = gemeinde_x$name,
                                      bfs_nr_old = entries_state_old$bfs_nr,
                                      name_old   = entries_state_old$name)
    }
  }
  
  
  mapped <- do.call(rbind, mapped_list)
  mapped <- mapped %>% arrange(bfs_nr_new)
  
  unmapped_full <- do.call(rbind, non_mapped_list)
  unmapped_full <- unmapped_full %>% arrange(bfs_nr_new)
  
  unmapped_state_new <- select(unmapped_full, bfs_nr_new, name_new) %>% unique()
  unmapped_state_old <- select(unmapped_full, bfs_nr_old, name_old) %>% unique()
  
  unmapped <- list(state_old = unmapped_state_old, state_new = unmapped_state_new)
  
  return(list(mapped = mapped, unmapped = unmapped, 
              state_old = state_old, state_new = state_new))
}
