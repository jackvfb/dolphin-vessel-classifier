library(readr)
library(dplyr)

log_counts <- function(data, label, log_file) {
  counts <- data %>% count(label)
  log_message <- paste0(
    "Subset - ", label, " counts:\n",
    paste(paste(counts$label, counts$n, sep = ": "), collapse = "\n"),
    "\nTotal: ", sum(counts$n), "\n\n"
  )
  cat(log_message, file = log_file, append = TRUE)
}

subset_data <- function(data, day_exclude, log_file) {
  wo <- filter(data, date != day_exclude)
  w <- filter(data, date == day_exclude)

  log_counts(wo, "Date excluded", log_file)
  log_counts(w, "Date only", log_file)

  write_csv(wo, snakemake@output[[1]])
  write_csv(w, snakemake@output[[2]])
}

feature_file <- read_csv(snakemake@input[[1]], col_types="ddddddddddcc")

subset_data(feature_file, snakemake@wildcards[[1]], snakemake@log[[1]])
