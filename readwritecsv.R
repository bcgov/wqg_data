library(tidyverse)
library(magrittr)

data <- read_csv("all_wqgs.csv")

data$Samples[is.na(data$Samples)] <- 1

write_csv(data, "all_wqgs.csv", na = "")

