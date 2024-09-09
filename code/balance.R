library(readr)
library(dplyr)

log_counts <- function(data, label, log_file) {
  counts <- data %>% count(label)
  log_message <- paste0(
    "Balance - ", label, " counts:\n",
    paste(paste(counts$label, counts$n, sep = ": "), collapse = "\n"),
    "\nTotal: ", sum(counts$n), "\n\n"
  )
  cat(log_message, file = log_file, append = TRUE)
}

balance_data <- function(data, log_file) {
  log_counts(data, "Before balancing", log_file)
  
  balanced_n <- min(count(data, label)$n)
  
  balanced_data <- data %>%
    group_by(label) %>%
    slice_sample(n = balanced_n) %>%
    ungroup()
  
  log_counts(balanced_data, "After balancing", log_file)
  
  write_csv(balanced_data, snakemake@output[[1]])
}

data <- read_csv(snakemake@input[[1]], col_types="ddddddddddcc")
balance_data(data, snakemake@log[[1]])
