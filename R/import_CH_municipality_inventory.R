#' Import the Swiss Municipality inventory
#'
#' This function imports the Swiss municipality inventory from the raw XML
#' resource into R as a \code{\link[tibble]{tibble}}. The imported table is the
#' basis to map the Swiss municipalities from an old to a new state (see
#' \code{\link{map_old_to_new_state}}).
#'
#' This imported Swiss municipality inventory is a database with the complete
#' mutation history that occured since 01.01.1960. The Swiss municipality inventory is
#' made available by the Federal Statistical Office and updated regularly to
#' keep track of new mutations.
#'
#' \strong{Download}
#'
#' See BfS webpage for infos about Swiss municipality inventory:
#' \href{https://www.bfs.admin.ch/bfs/de/home/grundlagen/agvch/historisiertes-gemeindeverzeichnis.assetdetail.11467405.html}{Historisiertes
#' Gemeindeverzeichnis}
#'
#' @param file_path Character vector of length one. It contains the file path to
#'   the Swiss municipality inventory XML file.
#'
#' @return A list with two tables in the form of tibble objects.
#'   \enumerate{\item Municipality mutations. \item Canton mutations}
#'
#' @seealso \code{\link{map_old_to_new_state}}
#'
#' @export
#' 
import_CH_municipality_inventory <- function(file_path) {
  
  if (!file.exists(file_path)) {
    stop(paste0("The given path (file_path = ", file_path, ") is not a file path to an existing file. Change the input of argument \"file_path\" "))
  }
  
  # XML import --------------------------------------------------------------
  xml_parsed <- xmlParse(file_path)
  
  # Process canton mutations object -----------------------------------------
  
  mutations_cantons <- xmlToDataFrame(nodes = getNodeSet(xml_parsed, "/eCH-0071:nomenclature/cantons/canton"))
  mutations_cantons <- tibble::as_tibble(mutations_cantons)
  
  
  mutations_cantons$cantonId            <- as.integer(as.character(mutations_cantons$cantonId))
  mutations_cantons$cantonAbbreviation  <- as.character(mutations_cantons$cantonAbbreviation)
  mutations_cantons$cantonLongName      <- as.character(mutations_cantons$cantonLongName)
  mutations_cantons$cantonDateOfChange  <- as.Date(as.character(mutations_cantons$cantonDateOfChange))
  
  mutations <- rename(mutations_cantons,
                      canton = cantonAbbreviation,
                      change_date = cantonDateOfChange)
  
  
  # Process municipality mutations object -----------------------------------
  
  mutations <- xmlToDataFrame(nodes = getNodeSet(xml_parsed, "/eCH-0071:nomenclature/municipalities/municipality"))
  mutations <- tibble::as_tibble(mutations)
  

  # Define column types -----------------------------------------------------
  
  mutations$historyMunicipalityId       <- as.integer(as.character(mutations$historyMunicipalityId))
  mutations$districtHistId              <- as.integer(as.character(mutations$districtHistId))
  mutations$cantonAbbreviation          <- as.character(mutations$cantonAbbreviation)
  mutations$municipalityId              <- as.integer(as.character(mutations$municipalityId))
  mutations$municipalityLongName        <- as.character(mutations$municipalityLongName)
  mutations$municipalityShortName       <- as.character(mutations$municipalityShortName)
  mutations$municipalityEntryMode       <- as.integer(as.character(mutations$municipalityEntryMode))
  mutations$municipalityStatus          <- as.integer(as.character(mutations$municipalityStatus))
  mutations$municipalityAdmissionNumber <- as.integer(as.character(mutations$municipalityAdmissionNumber))
  mutations$municipalityAdmissionMode   <- as.integer(as.character(mutations$municipalityAdmissionMode))
  mutations$municipalityAdmissionDate   <- as.Date(as.character(mutations$municipalityAdmissionDate))
  mutations$municipalityAbolitionNumber <- as.integer(as.character(mutations$municipalityAbolitionNumber))
  mutations$municipalityAbolitionMode   <- as.integer(as.character(mutations$municipalityAbolitionMode))
  mutations$municipalityAbolitionDate   <- as.Date(as.character(mutations$municipalityAbolitionDate))
  mutations$municipalityDateOfChange    <- as.Date(as.character(mutations$municipalityDateOfChange))
  
  
  # Modify and select columns -----------------------------------------------
  
  mutations <- rename(mutations,
                      hist_id          = historyMunicipalityId,
                      district_hist_id = districtHistId,
                      canton           = cantonAbbreviation,
                      bfs_nr           = municipalityId,
                      name             = municipalityShortName,
                      entry_mode       = municipalityEntryMode,
                      status           = municipalityStatus,
                      admission_nr     = municipalityAdmissionNumber,
                      admission_mode   = municipalityAdmissionMode,
                      admission_date   = municipalityAdmissionDate,
                      abolition_nr     = municipalityAbolitionNumber,
                      abolition_mode   = municipalityAbolitionMode,
                      abolition_date   = municipalityAbolitionDate,
                      change_date      = municipalityDateOfChange)
  
  
  # - Long name not needed
  # - status always = 1
  # - Entry mode: Unknown purpose
  mutations <- select(mutations, -municipalityLongName, -status, -entry_mode)
  
  return(list(mutations = mutations, mutations_cantons = mutations_cantons))
}
