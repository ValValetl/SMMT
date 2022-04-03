#' Download municipality inventory
#'
#' This functions downloads and extracts the municipality inventory form a
#' defined online source.
#'
#' @param url Character vector of length one. Link to the zip file containing
#'   the municipality inventory.
#' @param path Character vector of length one. Destination of extracted xml
#'   file.
#' @param verbose Get a message after download about the content of the
#'   inventory.
#'
#' @return Character vector of length one. File path to the extracted XML file.
#'
#' @export
#' 

download_municipality_inventory <- function(url = get_current_url(),
                                            path = getwd(), verbose = TRUE) {
  
  destfile <- file.path(tempdir(), "municipality_inventory.zip")
  
  curl::curl_download(url = url, destfile = destfile)
  
  file_list_zip <- unzip(zipfile = destfile, list = TRUE)
  file_list_zip <- as_tibble(file_list_zip)
  file_list_zip <- add_column(file_list_zip, is_xml = grepl(".xml", file_list_zip$Name))
  file_list_zip <- mutate(file_list_zip, is_draft = grepl("DRAFT", Name))
  
  file_list_zip <- filter(file_list_zip, is_draft != TRUE)
  file_list_zip_relevant <- filter(file_list_zip, is_xml == TRUE)
  
  unzip(zipfile = destfile, files = file_list_zip_relevant$Name, exdir = tempdir(), overwrite = FALSE)
  copy_success <- file.copy(file.path(tempdir(), file_list_zip_relevant$Name), to = path, overwrite = FALSE)
  
  if (!copy_success)
    stop(paste0("XML File already exists at target (", path, ") location"))
  
  xml_file_path <- file.path(path, basename(file_list_zip_relevant$Name))
  
  if (verbose) {
    mutations_object <- import_CH_municipality_inventory(file_path = xml_file_path)
    
    message <- paste0("Municipal inventory successfully obtained. Most recent mutations enregistered: ", 
                      format(date_of_last_update(mutations_object$mutations), "%d.%m.%Y"), ".")
    
    message(message)
  }
  
  return(xml_file_path)
}
