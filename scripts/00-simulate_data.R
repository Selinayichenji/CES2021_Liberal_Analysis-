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
# Test if gender only contains "Female" and "Male"
expect_setequal(unique(liberal_support$gender), c("Female", "Male"))

# Test if age groups match the expectations
expect_setequal(unique(liberal_support$age), c("<30", "30-39", "40-49", "50-59", "60+"))

# Test if the number of children contains expected values
expect_setequal(unique(liberal_support$child_number), c("0", "1", "2", "3", "4", "5+"))

# Test if income contains expected values
expect_setequal(unique(liberal_support$income), c("<$25k", "$25k-$49k", "$50k-$74k", "$75k-$99k", "$100k-$124k", "$125k+"))

# Test if education levels contain expected values
expect_setequal(unique(liberal_support$education), c("< High school", "High school", "Non-University", "Bachelor", "Post-grad"))

# Test if voting choice only contains "yes" and "no"
expect_setequal(unique(liberal_support$liberal_vote), c("yes", "no"))

