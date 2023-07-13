library(tidyverse)
library(magrittr)
library(wqbc)
library(rems)

data <- read_csv("all_wqgs.csv")

data <- data %>%
  dplyr::filter_all(dplyr::any_vars(!is.na(.)))

distinct(select(data, Type, Days, Samples, Direction, Statistic)) %>%
  filter(!is.na(Direction)) %>%
  arrange(Type, Days, Samples, Direction, Statistic)

data %<>% filter(Type == "Long-term chronic", Days == 1)

#codes <- wqbc::ems_codes

codes <- rems::ems_parameters %>%
  select(EMS_CODE = PARAMETER_CODE,
         EMS_VARIABLE = PARAMETER) %>%
  mutate_all(stringr::str_trim, side = "both") %>%
  distinct()

codes$EMS_CODE %<>% paste0("EMS_", .)

missing_codes <- anti_join(data, codes, by = c(EMS_Code = "EMS_CODE"))

missing_codes %<>% distinct(Variable, EMS_Code)

missing_codes$EMS_Code[missing_codes$EMS_Code == "EMS_NA"] <- NA

filter(missing_codes, is.na(EMS_Code))

filter(missing_codes, !is.na(EMS_Code))

