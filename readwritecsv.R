library(tidyverse)
library(magrittr)

data <- read_csv("all_wqgs.csv")

missing <- filter(data, is.na(EMS_Code))

data %<>% filter(!is.na(EMS_Code))

data %<>% separate(EMS_Code, paste0("EMS_Code", 1:4), sep = "\\s*,\\s*")

data %<>% pivot_longer(paste0("EMS_Code", 1:4), names_to = "EMS_Code_Number", values_to = "EMS_Code")

data %<>%
  filter(!is.na(EMS_Code))

data %<>% select(colnames(missing))

data %<>% bind_rows(missing)

write_csv(data, "all_wqgs.csv", na = "")
