library(tidyverse)
library(magrittr)
library(wqbc)
library(rems)
library(daff)

data <- read_csv("all_wqgs.csv")

data_old <- data

calc_limit <- function (x, cvalues) {
  x <- try(eval(parse(text = as.character(x)), envir = cvalues), silent = TRUE)
  if(class(x) != "numeric")
    return (NA)
  x
}

cvalues <- list(EMS_0004 = 10, EMS_0013 = 10, EMS_0107 = 10,
                EMS_HGME = 10, EMS_HG_T = 10, EMS_CA_D = 10,
                EMS_1107 = 10, EMS_0104 = 10)

x <- unique(data$Limit[!is.na(data$Limit)])
# x <- x[str_detect(x, "EMS_")]

for(i in x){
  print(i)
  y <- calc_limit(i, cvalues)
  if(is.na(y)) break
}

data$Limit %<>%
  str_replace_all("0.000 01",
                  "0.00001")

if(FALSE) {
  patch <- diff_data(data_old, data)
  render_diff(patch)

  write_csv(data, "all_wqgs.csv", na = "")
  saveRDS(patch, "patch.RDS")
}

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

