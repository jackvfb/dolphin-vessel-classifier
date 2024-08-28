library(readr)
library(dplyr)

balance_data <- function(data) {
  balanced_n <- min(count(data, label)$n)
  
  balanced_data <- data %>%
    group_by(label) %>%
    slice_sample(n = balanced_n) %>%
    ungroup()
  
  write_csv(balanced_data, snakemake@output[[1]])
}
  
data <- read_csv(snakemake@input[[1]], col_types="ddddddddddcc")
balance_data(data)



