#### Preamble ####
# Purpose: Build a multi-level logistic linear regression model for the Liberal Party in CES2021
# Author: Yichen Ji
# Date: 27 March 2024
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites:download packages tidyverse, rstanarm and arrow
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)
library(plumber)

#### Read data ####
analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")

### Model data ####

#Reorder the categories in education level group
analysis_data$education_level <- factor(analysis_data$education_level,
                                        levels = c("Less than high school", 
                                                   "High school", 
                                                   "Non-University",
                                                   "University certificate below the bachelor", 
                                                   "Bachelor's degree", 
                                                   "Above the bachelor"))

liberal_model <- stan_glmer(
  vote_liberal ~ age + gender + education_level + family_income + children_number + (1 | province),
  data = analysis_data,
  family = binomial(link = "logit"),
  prior = normal(0, 2.5, autoscale = TRUE), 
  prior_intercept = normal(0, 2.5, autoscale = TRUE), 
  seed = 2024,
  chains = 4,
  cores = 4,
  control = list(adapt_delta = 0.99)
)

#Save the model
saveRDS(liberal_model, file = "models/liberal_model.rds")

