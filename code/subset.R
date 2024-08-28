library(readr)
library(dplyr)

subset_data <- function(data, day_exclude) {
  wo <- filter(data, date != day_exclude)
  w <- filter(data, date == day_exclude)

  write_csv(wo, snakemake@output[[1]])
  write_csv(w, snakemake@output[[2]])
}

feature_file <- read_csv(snakemake@input[[1]],
                         col_types="ddddddddddcc")

subset_data(feature_file, snakemake@wildcards[[1]])

