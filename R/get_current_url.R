#' Get URL of current XML data set
#' 
#' Extract the url from the static source web page.
#' 
#' @return Returns URL to municipality inventory

get_current_url <- function() {
  
  url_xml_link <- file.path("https://www.bfs.admin.ch", 
                            "bfs/de/home/statistiken/kataloge-datenbanken.assetdetail.dz-b-00.04-hgv-02.html")
  
  hp_object <- read_html(url_xml_link)
  current_url <- html_nodes(hp_object,"a") %>% html_attr("href")
  current_url <- current_url[grep("assets", current_url, perl = FALSE)]
  current_url <- unique(current_url[grep("master", current_url, perl = FALSE)])
  
  if (length(current_url) > 1) {
    stop("error: Link detection failed.")
  }
  
  return(current_url)
}
