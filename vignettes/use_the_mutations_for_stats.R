## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(SMMT)


## ---- eval=FALSE--------------------------------------------------------------
#  
#  # Import the municipality inventory
#  mutations_object <- import_CH_municipality_inventory(file_path = path_inventory_xml)
#  
#  # Specify a date vector
#  dates <- seq.Date(from = as.Date("1980-01-01"), to = as.Date("2020-01-01"), by = "1 year")
#  
#  # Obtain the municipality count for this date vector
#  sy_municipality <- municipality_counter(mutations_object$mutations, dates, geo_level = "ch")
#  
#  # Second example for one point in time:
#  sy_municipality <- municipality_counter(mutations_object$mutations, "2001-04-04", geo_level = "ch")

## ---- eval=FALSE--------------------------------------------------------------
#  
#  mutations_object <- import_CH_municipality_inventory(file_path = path_inventory_xml)
#  
#  dates <- seq.Date(from = as.Date("1980-01-01"), to = as.Date("2020-01-01"), by = "1 year")
#  sy_municipality <- municipality_counter(mutations_object$mutations, dates, geo_level = "cantons")

