library(tidyverse)
library(magrittr)

data <- read_csv("all_wqgs.csv")

data$EMS_Code %<>% paste0("EMS_", .)

write_csv(data, "all_wqgs.csv", na = "")
