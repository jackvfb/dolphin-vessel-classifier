# Load required packages
library(targets)
library(tarchetypes)
library(future)
library(tidyverse)

plan(multisession)

# File containing commands referenced in this pipeline
source("R/functions.R")

# --- Individual Targets

# 1
#
# Name:
# raw_data
#
# Description:
# Data file provided by Roee with whistles features. Annotated
# with presence of or absence of URN in the "label" column.
# See Diamant et al. (2024) for details.

T1 <- tar_target(raw_data, "study_data.csv", format = "file")

# 2
#
# Name:
# study_data
#
# Description:
# Clean data that was read in properly and cleaned

T2 <- tar_target(study_data, read_study_data(raw_data), format = "rds")

# --- Mapped Targets

# Values:
# List of dates supplied for purpose of subsetting the data.
# This is necessary because a different model will be trained to be tested
# on the data from an individual day. See Diamant et al. (2024).

T_MAPPED <- tar_map(
  values = list(date = c("2021_06_24", "2021_06_25", "2021_06_26", "2021_06_27", "2021_06_28",
                       "2021_06_29", "2021_06_30", "2021_07_01", "2021_07_02", "2021_07_03",
                       "2021_07_04", "2021_07_05", "2021_07_06", "2021_07_07", "2021_07_08",
                       "2021_07_09", "2021_07_10", "2021_07_11", "2021_07_12", "2021_07_13",
                       "2021_07_14", "2021_07_15"
                       )
                ),
  
  # 1
  # 
  # Name:
  # training_data_XXX
  # xxx denotes date
  #
  # Description:
  # For the date specified, will subset study_data to exclude the date.
  
  tar_target(
    name = training_data,
    command = subset_and_balance_training_data(study_data, date),
    deployment = "worker"
    ),
  
  # 2
  #
  # Name:
  # testing_data_XXX
  # xxx denotes date
  
  # Description:
  # For the date specified, will subset study_data to include only the date.
  tar_target(
    name = testing_data,
    command = subset_testing_data(study_data, date),
    deployment = "worker"
  ),
  
  # 3
  #
  # Name:
  # svm_XXX
  # xxx denotes date
  #
  # Description:
  # An SVM model trained on on the data exluding the date denoted
  tar_target(
    name = svm,
    command = do_model(training_data),
    deployment = "worker"
  ),
  
  # 4
  #
  # Name:
  # svm_predictions_XXX
  # xxx denotes date
  #
  # Description:
  # Results of model predictions for data from the date denoted.
  tar_target(
    name = svm_predictions,
    command = do_predict(svm, testing_data),
    deployment = "worker"
  )
)

# --- COMBINED TARGETS

# Values:
# Model predictions for models trained for all dates

# Name:
# combined_predictions
#
# Description:
# Pertinent data concerning the predictions, available for all models
# included in the study

T_COMBINED <- tar_combine(
  combined_predictions,
  T_MAPPED[["svm_predictions"]],
  command = aggregate_predictions(!!!.x)
)

# --- EXECUTE PIPELINE

list(
  T1,
  T2,
  T_MAPPED,
  T_COMBINED
)