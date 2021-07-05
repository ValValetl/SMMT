## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(SMMT)


## ---- eval=FALSE--------------------------------------------------------------
#  path_inventory_xml <- download_municipality_inventory(path = getwd())

## ---- eval=FALSE--------------------------------------------------------------
#  mutations_object <- import_CH_municipality_inventory(file_path = path_inventory_xml)
#  mutations        <- mutations_object$mutations
#  
#  # Alternative: Use a local available version (e.g. Version from January 1st, 2018):
#  file_path_inventory_xml <- "path/to/eCH0071_180101.xml"
#  mutations_object <- import_CH_municipality_inventory(file_path = file_path_inventory_xml)
#  mutations        <- mutations_object$mutations

## -----------------------------------------------------------------------------
old_state <- as.Date("1961-01-01")
new_state <- as.Date("1963-01-01")

## ---- echo = FALSE------------------------------------------------------------
mutations <- structure(list(hist_id = c(11227L, 11240L, 13189L),
district_hist_id = c(10025L, 10025L, 10025L),
kanton_abbr = c("AG", "AG", "AG"),
bfs_nr = c(4025L, 4021L, 4021L),
name = c("Daettwil", "Baden", "Baden"),
admission_nr = c(1000L, 1000L, 1004L),
admission_mode = c(20L, 20L, 26L),
admission_date = structure(c(-3653, -3653, -2922), class = c("Date")),
abolition_nr = c(1004L, 1004L, NA),
abolition_mode = c(29L, 26L, NA),
abolition_date = structure(c(-2923, -2923, NA), class = c("Date")),
change_date = structure(c(-2923, -2923, -2922), class = c("Date"))),
row.names = c(NA, -3L), class = c("tbl_df", "tbl", "data.frame"))

## -----------------------------------------------------------------------------
mapping_object <- map_old_to_new_state(mutations, old_state, new_state)
mapping_table  <- mapping_object$mapped

