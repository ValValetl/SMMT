#' Territorial mutation coutn
#' 
#' @inherit mutation_count
#' 
#' @export
#' 
territorial_mutation_count <- function(mutations, start_date, end_date = Sys.Date()) {
  
  return(mutation_count(mutations, start_date = start_date, 
                        end_date = end_date, territorial_changes_only = TRUE))
  
  
}
