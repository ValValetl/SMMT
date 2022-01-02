
test_that("no mutations results in empty tibble", {
  mutations_no_irrev <- structure(
    list(hist_id = c(11227L, 11240L, 13189L), 
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
  
  expected <- tibble(hist_id = integer(), 
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
  
  result <- get_irreversible_municipality_mutations(mutations_no_irrev)
  
  expect_identical(object = result, expected = expected)
})


test_that("Irreversible mutation is detected", {
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
  
  expected <- tibble(hist_id = c(11320L, 13668L, 13669L),
                     district_hist_id = c(10024L, 10024L, 10024L),
                     kanton_abbr = c("AG", "AG", "AG"),
                     bfs_nr = c(4061L, 4061L, 4084L), 
                     name = c("Arni-Islisberg", "Arni (AG)", "Islisberg"), 
                     admission_nr = c(1000L, 1481L, 1481L), 
                     admission_mode = c(20L, 21L, 21L), 
                     admission_date = structure(c(-3653,  4748,  4748), class = c("Date")), 
                     abolition_nr = c(1481L, NA, NA), 
                     abolition_mode = c(29L, NA, NA), 
                     abolition_date = structure(c(4747,   NA,   NA), class = c("Date")), 
                     change_date = structure(c(4747, 4748, 4748), class = c("Date")),
                     change_nr = rep(1481L, 3),
                     state = c("abolition", "admission", "admission"),
                     cause = rep("Gemeindetrennung", 3))
  
  result <- get_irreversible_municipality_mutations(mutations)
  
  expect_identical(result, expected)
})
