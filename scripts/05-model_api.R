#### Preamble ####
# Purpose: Build API for the Liberal Model
# Author: Yichen Ji
# Date: 27 March 2024
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites:download packages plumber, rstanarm and arrow
# Any other information needed? None



# Load necessary libraries
library(plumber)
library(rstanarm)
library(arrow)

# Assuming your stan_glmer model is saved as 'liberal_model.rds'
# Load your previously saved stan_glmer model

liberal_model <- readRDS("../models/liberal_model.rds")

#* @apiTitle Voting Prediction API
#* @apiDescription This API predicts the likelihood of an individual voting for the Liberal Party based on a statistical model.

#* @param age The age of the individual.
#* @param gender The gender of the individual: 'male', 'female', or other categories if applicable.
#* @param education_level The highest education level of the individual.
#* @param family_income The annual family income of the individual.
#* @param children_number The number of children in the individual's family.
#* @param province The province of the individual.
#* @post /predictVote
function(age, gender, education_level, family_income, children_number, province) {
  # Convert parameters to the correct type
  age <- as.factor(age)
  gender <- as.factor(gender)
  education_level <- as.factor(education_level)
  family_income <- as.factor(family_income)
  children_number <- as.factor(children_number)
  province <- as.factor(province)
  
  # Create a new data frame for prediction
  new_data <- data.frame(age = age,
                         gender = gender,
                         education_level = education_level,
                         family_income = family_income,
                         children_number = children_number,
                         province = province)
  
  # Make prediction using the `liberal_model`
  simulated_predictions <- posterior_predict(liberal_model, newdata = new_data)
  
  # Calculate the mean of the simulated predictions
  mean_prediction <- mean(simulated_predictions)
  
  # Return the mean prediction as a single probability value
  return(list(prediction = mean_prediction))
  
}

#* @plumber
function(pr) {
  pr
}