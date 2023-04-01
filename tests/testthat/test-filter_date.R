

test_that("correct selection is included when filtering on date", {
  
  mutations <- structure(list(hist_id = c(11320L, 13668L, 13669L),
                              district_hist_id = c(10024L, 10024L, 10024L),
                              kanton_abbr = c("AG", "AG", "AG"),
                              bfs_nr = c(4061L, 4061L, 4084L), 
                              name = c("Arni-Islisberg", "Arni (AG)", "Islisberg"), 
                              admission_nr = c(1000L, 1481L, 1481L), 
                              admission_mode = c(20L, 21L, 21L), 
                              admission_date = structure(c(-3653,  4748,  4748), class = c("Date")), 
                              abolition_nr = c(1481L, NA, NA), 
                              abolition_mode = c(29L, NA, NA), 
                              abolition_date = structure(c(4747, NA, NA), class = c("Date")), 
                              change_date = structure(c(4747, 4748, 4748), class = c("Date"))),
                         row.names = c(NA, -3L), class = c("tbl_df", "tbl", "data.frame"))
  
  # Corner case, last day of existence
  stand_19821231 <- filter_date(tbl = mutations, date = "1982-12-31")
  
  # Normal case
  stand_19830101 <- filter_date(tbl = mutations, date = "1983-01-01")
  
  # Only check the primary key, as this should be enough
  expect_identical(stand_19821231$hist_id, 11320L)
  expect_identical(stand_19830101$hist_id, c(13668L, 13669L))
  
})
