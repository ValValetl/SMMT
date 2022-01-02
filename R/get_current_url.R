#' Get URL of current XML data set
#' 
#' Extract the url from the static source web page.
#' 
#' @return Returns URL to municipality inventory

get_current_url <- function() {
  
  base_url <- "https://www.bfs.admin.ch"
  url_xml_link <- file.path(base_url, "bfs/de/home/statistiken/kataloge-datenbanken.assetdetail.dz-b-00.04-hgv-02.html")
  
  hp_object <- read_html(url_xml_link)
  path <- html_nodes(hp_object,"a") %>% html_attr("href")
  path <- path[grep("assets", path, perl = FALSE)]
  path <- unique(path[grep("master", path, perl = FALSE)])
  
  if (length(path) > 1) {
    stop("error: Link detection failed.")
  }
  
  current_url <- paste0(base_url, path)
  
  return(current_url)
}

