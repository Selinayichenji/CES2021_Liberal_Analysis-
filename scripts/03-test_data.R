#### Preamble ####
# Purpose: Test data
# Author: Yichen Ji
# Date: 27 March 2024
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites: none
# Any other information needed? No.

#### Workspace setup ####
library(arrow)
library(testthat)
analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")

#### Test data ####

#test gender and age group
expect_setequal(unique(analysis_data$gender), c("Female", "Male"))


expect_setequal(unique(analysis_data$age), c("18-29", "30-44", "45-59", "60-74", "75+"))


#test binomial result of vote
expect_true(all(analysis_data$vote_liberal %in% c(0, 1)))

expect_true(all(analysis_data$vote_conservative %in% c(0, 1)))

expect_true(all(analysis_data$vote_NDP %in% c(0, 1)))


#test provinces
expected_provinces <- c("British Columbia", "Ontario", "Manitoba", "Alberta",
                        "New Brunswick", "Newfoundland and Labrador",
                        "Nova Scotia", "Prince Edward Island", "Saskatchewan")

expect_setequal(unique(analysis_data$province), expected_provinces)

