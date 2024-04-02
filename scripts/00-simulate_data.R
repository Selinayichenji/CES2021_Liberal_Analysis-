#### Preamble ####
# Purpose: Simulate data for election survey
# Author: Yichen Ji
# Date: 09 March 2024
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download tidyverse package
# Any other information needed? No.

#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
set.seed(853)

liberal_support <-
  tibble(
    state = sample(1:50, size = 1000, replace = TRUE),
    gender = sample(c(1, 2), size = 1000, replace = TRUE),
    noise = rnorm(n = 1000, mean = 0, sd = 10) |> round(),
    supports = if_else(state + gender + noise > 50, 1, 0)
  )

political_support