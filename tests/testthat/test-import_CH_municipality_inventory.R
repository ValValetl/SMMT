
test_that("error is thrown if file does not exist", {
  expect_error(object = import_CH_municipality_inventory("non_existing_file_path"))
})
