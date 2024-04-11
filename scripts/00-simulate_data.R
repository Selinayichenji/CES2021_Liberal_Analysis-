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
library(testthat)

#### Simulate data ####
set.seed(853)

num_obs <- 1000

liberal_support <- tibble(
  age = sample(0:4, size = num_obs, replace = TRUE),
  child_number = sample(0:5, size = num_obs, replace = TRUE),
  income = sample(0:5, size = num_obs, replace = TRUE),
  education = sample(0:4, size = num_obs, replace = TRUE),
  gender = sample(0:1, size = num_obs, replace = TRUE),
  support_prob = ((education + gender + age + child_number + income) / 5),
) %>%
  mutate(
    liberal_vote = if_else(runif(n= num_obs) < support_prob, "yes", "no"),
    education = case_when(
      education == 0 ~ "< High school",
      education == 1 ~ "High school",
      education == 2 ~ "Non-University",
      education == 3 ~ "Bachelor",
      education == 4 ~ "Post-grad"
    ),
    gender = if_else(gender == 0, "Male", "Female"),
    age = case_when(
      age == 0 ~ "<30",
      age == 1 ~ "30-39",
      age == 2 ~ "40-49",
      age == 3 ~ "50-59",
      age == 4 ~ "60+"
    ),
    child_number = case_when(
      child_number == 0 ~ "0",
      child_number == 1 ~ "1",
      child_number == 2 ~ "2",
      child_number == 3 ~ "3",
      child_number == 4 ~ "4",
      child_number == 5 ~ "5+"
    ),
    income = case_when(
      income == 0 ~ "<$25k",
      income == 1 ~ "$25k-$49k",
      income == 2 ~ "$50k-$74k",
      income == 3 ~ "$75k-$99k",
      income == 4 ~ "$100k-$124k",
      income == 5 ~ "$125k+"
    )
  ) %>%
  select(-support_prob, liberal_vote, gender, education, age, child_number, income)

# Test simulated data
# Test if 'gender' contains only 'Female' and 'Male'
expect_setequal(unique(analysis_data$gender), c("Female", "Male"))

# Test if 'age' contains the specified age groups
expect_setequal(unique(analysis_data$age), c("18-29", "30-44", "45-59", "60-74", "75+"))

# Test that 'vote_liberal' only contains binary results
expect_true(all(analysis_data$vote_liberal %in% c(0, 1)))

# Test that 'vote_conservative' only contains binary results
expect_true(all(analysis_data$vote_conservative %in% c(0, 1)))

# Test that 'vote_NDP' only contains binary results
expect_true(all(analysis_data$vote_NDP %in% c(0, 1)))

# Test if 'province' contains the expected set of provinces
expected_provinces <- c("British Columbia", "Ontario", "Manitoba", "Alberta",
                        "New Brunswick", "Newfoundland and Labrador",
                        "Nova Scotia", "Prince Edward Island", "Saskatchewan")
expect_setequal(unique(analysis_data$province), expected_provinces)

