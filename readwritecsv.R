library(tidyverse)
library(magrittr)
library(wqbc)
library(rems)

data <- read_csv("all_wqgs.csv")

data %<>% mutate(Keep = is.na(Minimum) & is.na(Maximum))

data %<>% mutate(Minimum = as.character(Minimum)) %>%
  pivot_longer(c(Minimum, Maximum), names_to = "Direction") %>%
  filter(!is.na(value) | Keep)

data$Direction[data$Keep] <- NA

data %<>% distinct()

data$PredictedEffectLevel <- NA_character_

data %<>%  select(c("Variable", "EMS_Code", "Use", "Media", "Days", "Samples",
"Notes", "Condition", "PredictedEffectLevel", "Direction", Limit = "value", "Units", "Statistic",
"Type", "Reference", "Reference Link", "Overview Report Link",
"Technical Document Link"))

data$Direction %<>% str_replace("Maximum", "Upper") %>%
  str_replace("Minimum", "Lower")

data %<>% arrange(Variable, EMS_Code, Use, Media, Days, Samples)

write_csv(data, "all_wqgs.csv", na = "")

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

