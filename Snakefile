STUDY_DATES = ["2021_06_24", "2021_06_25"]

rule subset:
  input:
    "study_data.csv"
  output:
    temp("data/{date}/train_and_val.0.csv"),
    "data/{date}/test.csv"
  log:
    "logs/{date}/subset.log"
  script:
    "code/subset.R"
    
rule balance:
  input:
    "data/{date}/train_and_val.0.csv"
  output:
    "data/{date}/train_and_val.csv"
  log:
    "logs/{date}/balance.log"
  script:
    "code/balance.R"
    
rule split:
  input:
    "data/{date}/train_and_val.csv"
  params:
    p = 0.25
  output:
    "data/{date}/val.csv",
    "data/{date}/train.csv"
  script:
    "code/split.R"

rule seq_fs:
  input:
    "data/{date}/train_and_val.csv"
  output:
    "data/{date}/fs.rds"
  params:
    v = 5
  script:
    "code/seqfs.R"

rule test:
  input:
    expand("data/{date}/{set}.csv", set=["train", "val", "test"], date=STUDY_DATES)
