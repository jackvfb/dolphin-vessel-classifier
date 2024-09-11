library(tidyverse)

method_read <- function(input_csv) {
  data <- read_csv(input_csv, col_types = "ddddddddddff")
  return(data)
}

# wo_date <- function(data, date) {
#   wo <- data %>%
#     filter(date != date) %>%
#     select(-date)
#   
#   output_file <- paste0("data/wo_", date, ".rds")
#   saveRDS(wo, output_file)
# }

method_subset <- function(data_source, date_wanted) {
  result <- data_source %>%
    filter(date == {{date_wanted}}) %>%
    select(-{{date_wanted}})
  
  output_file <- paste0("data/w_", date_wanted, ".rds")
  saveRDS(w, output_file)
}

# test <- function(data) {
#   counts <- data %>% count(label)
#   saveRDS()
# }