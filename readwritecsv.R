library(tidyverse)
library(magrittr)

data <- read_csv("all_wqgs.csv")

write_csv(data, "all_wqgs.csv", na = "")

