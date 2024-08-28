library(readr)

split_data <- function(data, proportion) {
  sample_size <- floor(proportion * nrow(data))
  index <- sample(seq_len(nrow(data)), size = sample_size)
  
  write_csv(data[index, ], snakemake@output[[1]])
  write_csv(data[-index, ], snakemake@output[[2]])
}

data <- read_csv(snakemake@input[[1]],
                 col_types="ddddddddddff")

split_data(data, snakemake@params[["p"]])
