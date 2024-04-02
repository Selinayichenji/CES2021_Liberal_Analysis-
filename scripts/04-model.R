#### Preamble ####
# Purpose: Models for predicting 2024 Canadian election
# Author: Yichen Ji
# Date: 27 March 2024
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/analysis_data/analysis_data.parquet")

### Model data ####

liberal_model <- stan_glmer(
  vote_liberal ~ age + gender + education_level + family_income + children_number + (1 | province),
  data = data,
  family = binomial(link = "logit"),
  prior = normal(0, 2.5, autoscale = TRUE), 
  prior_intercept = normal(0, 2.5, autoscale = TRUE), 
  seed = 2024,
  chains = 4,
  cores = 4,
  control = list(adapt_delta = 0.99)
)

saveRDS(
  liberal_model,
  file = "liberal.rds"
)


conservative_model <- stan_glmer(
  vote_conservative ~ age + gender + education_level + family_income + children_number + (1 | province),
  data = data,
  family = binomial(link = "logit"),
  prior = normal(0, 2.5, autoscale = TRUE), 
  prior_intercept = normal(0, 2.5, autoscale = TRUE), 
  seed = 2024,
  chains = 4,
  cores = 4,
  control = list(adapt_delta = 0.99)
)

saveRDS(
  conservative_model,
  file = "liberal.rds"
)


NDP_model <- stan_glmer(
  vote_NDP ~ age + gender + education_level + family_income + children_number + (1 | province),
  data = data,
  family = binomial(link = "logit"),
  prior = normal(0, 2.5, autoscale = TRUE), 
  prior_intercept = normal(0, 2.5, autoscale = TRUE), 
  seed = 2024,
  chains = 4,
  cores = 4,
  control = list(adapt_delta = 0.99)
)
saveRDS(
  NDP_model,
  file = "liberal.rds"
)

#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)