library(tidyverse)
library(tidymodels)

read_study_data <- function(file_path) {
  read_csv(file_path,
           col_types = "ddddddddddff",
           col_select = -"harmony_mult_med") # Because contains NaN
}


subset_and_balance_training_data <- function(df, date_wanted) {
  result <- df %>%
    filter(date != date_wanted) %>%
    slice_sample(n=1000) %>% # only for development
    select(-date)
  
  balanced_n <- min(count(result, label)$n)
  
  balanced_result <- result %>%
    group_by(label) %>%
    slice_sample(n = balanced_n) %>%
    ungroup()
  
  return(balanced_result)
}

subset_testing_data <- function(df, date_wanted) {
  df %>%
    filter(date == date_wanted) %>%
    select(-date)
}

do_model <- function(df) {
  my_recipe <- 
    recipe(label ~ .,
           data = head(df)) %>% 
    step_normalize(all_numeric())
  
  my_svm <- 
    svm_rbf() %>%
    set_engine("kernlab") %>%
    set_mode("classification")
  
  my_wf <- 
    workflow() %>%
    add_recipe(my_recipe) %>%
    add_model(my_svm)
  
  fit(my_wf, df)
}

# Name
# Do Prediction
#
#

do_predict <- function(model, df) {
  tibble(truth = df$label,
         est = predict(model, new_data = df)$.pred_class
  )
}

aggregate_predictions <- function(...) {
  bind_rows(..., .id = "svm") %>%
    mutate(svm = str_extract(svm, "\\d{4}_\\d{2}_\\d{2}$"),
           .keep = "unused")
}
