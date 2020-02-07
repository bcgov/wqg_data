library(tidyverse)
library(magrittr)
library(wqbc)
library(rems)
library(daff)

data <- read_csv("all_wqgs.csv")

data_old <- data

data$EMS_Code %<>% str_replace("-", "_")

patch <- diff_data(data_old, data)
render_diff(patch)

if(FALSE) {
  write_csv(data, "all_wqgs.csv", na = "")

  saveRDS(patch, "patch.RDS")
}

distinct(select(data, Days, Samples, Direction, Statistic)) %>%
  filter(!is.na(Direction)) %>%
  arrange(Days, Samples, Direction, Statistic)

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

