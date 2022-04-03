## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(SMMT)


## ----code, eval=FALSE, include=TRUE-------------------------------------------
#  
#  start_date <- seq.Date(as.Date("1960-01-01"), to = as.Date("2022-01-01"), by = "1 year")
#  
#  res <- mutation_count(mutations = mutations_object$mutations,
#                        start_date, start_date + lubridate::years(1),
#                        territorial_changes_only = FALSE)
#  
#  
#  p <- ggplot(data = res, aes(start_date, number_of_mutations_in_period)) + geom_bar(stat = "identity")
#  print(p)
#  

## ----code2, eval=FALSE, include=TRUE------------------------------------------
#  
#  res <- territorial_mutation_count(mutations = mutations_object$mutations,
#                        start_date, start_date + lubridate::years(1))
#  
#  p <- ggplot(data = res, aes(start_date, number_of_mutations_in_period)) + geom_bar(stat = "identity")
#  print(p)
#  

