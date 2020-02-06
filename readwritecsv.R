library(tidyverse)
library(magrittr)
library(wqbc)
library(rems)
library(daff)

data <- read_csv("all_wqgs.csv")

data_old <- data

data %>% filter(Samples == 1, Days == 1, Statistic == "mean")

data$Statistic[data$Statistic == "mean" &
                 data$Samples == 1 &
                 data$Days == 1] <- "max"

render_diff(diff_data(data_old, data))

write_csv(data, "all_wqgs.csv", na = "")



distinct(select(data, Days, Samples, Statistic))

filter(data, EMS_Code %in% paste0("EMS_", c("0147", "0148", "0450"))) %>%
  select(Variable, EMS_Code, Use, Media, Days, Samples, Statistic, Notes) %>%
  arrange(EMS_Code) %>% pull(Notes)

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

