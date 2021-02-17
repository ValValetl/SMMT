#' Get irreversible municipality mutations
#'
#' This function detects irreversible mutations.
#'
#' Irreversible mutations are defined as mutations during which territories are
#' split up. There are different types of irreversible mutations drawn from the
#' below cited document. In contrast, normal mutations signify a simple
#' merging of territory which accounts for most of the mutations in Switzerland
#' since 1960 whereas irreversible mutations occurred only rarely. The aim of
#' this function is to filter for these irreversible mutations. These can then
#' be treated separatly.
#'
#' Definitions for different types of territory split ups are based on:
#' Erläuterungen und Anwendungen - Historisierte Gemeindeverzeichnis der Schweiz
#' (2017).
#'
#' @param mutations A tibble with municipality mutations (as created by
#'   \code{\link{import_CH_municipality_inventory}})
#'
#' @return A tibble with all the instances of irreversibe mutations. The
#'   irreversibility cause is part of the output.
#'   
#'   
#' @examples
#' 
#'   mutations <- structure(list(hist_id = c(11320L, 13668L, 13669L),
#'  district_hist_id = c(10024L, 10024L, 10024L),
#'  kanton_abbr = c("AG", "AG", "AG"),
#'  bfs_nr = c(4061L, 4061L, 4084L), 
#'  name = c("Arni-Islisberg", "Arni (AG)", "Islisberg"), 
#'  admission_nr = c(1000L, 1481L, 1481L), 
#'  admission_mode = c(20L, 21L, 21L), 
#'  admission_date = structure(c(-3653, 4748,  4748),
#'  class = c("Date")), 
#'  abolition_nr = c(1481L, NA, NA), 
#'  abolition_mode = c(29L, NA, NA), 
#'  abolition_date = structure(c(4747, NA, NA),
#'  class = c("Date")), 
#'  change_date = structure(c(4747, 4748, 4748),
#'  class = c("Date"))), 
#'  row.names = c(NA, -3L), class = c("tbl_df", "tbl", "data.frame"))
#'    
#' irreversible_mutations <- get_irreversible_municipality_mutations(mutations)
#' 
#' @export

get_irreversible_municipality_mutations <- function(mutations) {
  
  # Gemeindetrennung --------------------------------------------------------
  counter <- 1
  
  gemeindetrennung_list_abol <- list()
  gemeindetrennung_list_adm  <- list()
  
  all_abolition_nrs <- sort(unique(mutations$abolition_nr))
  for (ii in all_abolition_nrs) {
    
    mut_abol <- filter(mutations, abolition_nr == ii & abolition_mode == 29)
    mut_adm  <- filter(mutations, admission_nr == ii & admission_mode == 21)
    
    abol_cond <- nrow(mut_abol) == 1
    adm_cond  <- nrow(mut_adm) > 1
    
    if (abol_cond & adm_cond) {
      
      gemeindetrennung_list_abol[[counter]] <- add_column(filter(mutations, abolition_nr == ii), change_nr = ii)
      gemeindetrennung_list_adm[[counter]]  <- add_column(filter(mutations, admission_nr == ii), change_nr = ii)
      counter <- counter + 1
    }
  }
  
  gemeindetrennung <- rbind(
    add_column(bind_rows(gemeindetrennung_list_abol), state = "abolition", cause = "Gemeindetrennung"),
    add_column(bind_rows(gemeindetrennung_list_adm),  state = "admission", cause = "Gemeindetrennung"))
  
  
  # Gebietsabtausch ---------------------------------------------------------
  counter <- 1
  
  gebietstausch_list_abol <- list()
  gebietstausch_list_adm  <- list()
  
  all_abolition_nrs <- sort(unique(mutations$abolition_nr))
  for (ii in all_abolition_nrs) {
    
    mut_abol <- filter(mutations, abolition_nr == ii)
    mut_adm  <- filter(mutations, admission_nr == ii)
    
    abol_cond <- all(mut_abol$abolition_mode == 26) & nrow(mut_abol) > 0
    adm_cond  <- all(mut_adm$admission_mode == 26)  & nrow(mut_adm) > 0
    
    if (abol_cond & adm_cond) {
      
      gebietstausch_list_abol[[counter]] <- add_column(filter(mutations, abolition_nr == ii), change_nr = ii)
      gebietstausch_list_adm[[counter]]  <- add_column(filter(mutations, admission_nr == ii), change_nr = ii)
      counter <- counter + 1
    }
  }
  
  gebietstausch <- rbind(
    add_column(bind_rows(gebietstausch_list_abol), state = "abolition", cause = "Gebietstausch"),
    add_column(bind_rows(gebietstausch_list_adm),  state = "admission", cause = "Gebietstausch"))
  
  
  # Ausgemeindung -----------------------------------------------------------
  counter <- 1
  
  ausgemeindung_list_abol <- list()
  ausgemeindung_list_adm  <- list()
  
  all_abolition_nrs <- sort(unique(mutations$abolition_nr))
  for (ii in all_abolition_nrs) {
    
    mut_abol <- filter(mutations, abolition_nr == ii)
    mut_adm  <- filter(mutations, admission_nr == ii)
    
    abol_cond <- all(mut_abol$abolition_mode == 26) & nrow(mut_abol) > 0
    adm_cond  <- all(c(21, 26) %in% mut_adm$admission_mode) & nrow(mut_adm) > 0
    
    if (abol_cond & adm_cond) {
      
      ausgemeindung_list_abol[[counter]] <- add_column(filter(mutations, abolition_nr == ii), change_nr = ii)
      ausgemeindung_list_adm[[counter]]  <- add_column(filter(mutations, admission_nr == ii), change_nr = ii)
      counter <- counter + 1
    }
  }
  
  ausgemeindung <- rbind(
    add_column(bind_rows(ausgemeindung_list_abol), state = "abolition", cause = "Ausgemeindung"),
    add_column(bind_rows(ausgemeindung_list_adm),  state = "admission", cause = "Ausgemeindung"))
  
  
  # Spezialfall -------------------------------------------------------------
  # Change_nr 2299 scheint ein Spezialfall zu sein. Es ist unklar, ob es ein
  # Fehler ist in der ursprünglichen Mutationshistorytabelle
  change_nr_ <- 2299
  spezialfall <- rbind(
    add_column(filter(mutations, abolition_nr == change_nr_), change_nr = change_nr_, state = "abolition", cause = "Spezialfall"),
    add_column(filter(mutations, admission_nr == change_nr_), change_nr = change_nr_, state = "admission", cause = "Spezialfall"))
  
  mutations_irreversible <- rbind(gemeindetrennung,
                                  gebietstausch,
                                  ausgemeindung,
                                  spezialfall)
  
  if (nrow(mutations_irreversible) == 0) {
    
    mutations_irreversible <- tibble(hist_id = integer(), 
                                     district_hist_id = integer(),
                                     kanton_abbr = character(),
                                     bfs_nr = integer(), 
                                     name = character(),
                                     admission_nr = integer(), 
                                     admission_mode = integer(), 
                                     admission_date = structure(integer(), class = c("Date")), 
                                     abolition_nr = integer(),
                                     abolition_mode = integer(),
                                     abolition_date = structure(integer(), class = c("Date")),
                                     change_date = structure(integer(), class = c("Date")),
                                     state = character(),
                                     cause = character())
    
  }
  
  return(mutations_irreversible)
}
