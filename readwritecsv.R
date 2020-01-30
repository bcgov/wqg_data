library(tidyverse)
library(magrittr)
library(wqbc)

codes <- wqbc::ems_codes
codes$EMS_CODE %<>% paste0("EMS_", .)

data <- read_csv("all_wqgs.csv")

#write_csv(data, "all_wqgs.csv", na = "")


missing_codes <- anti_join(data, codes, by = c(EMS_Code = "EMS_CODE"))

missing_codes %<>% distinct(Variable, EMS_Code)

missing_codes$EMS_Code[missing_codes$EMS_Code == "EMS_NA"] <- NA

filter(missing_codes, is.na(EMS_Code))

filter(missing_codes, !is.na(EMS_Code))

