
library(arrow)
liberal_model <- readRDS("../models/liberal_model.rds")

# Enhancement: API for the linear model
#install.packages("plumber")
library(plumber)

#* @apiTitle Liberal Vote Prediction API
#* @apiDescription This API predicts the probability of voting liberal based on the model.

#* @param age The age of the individual.
#* @param gender The gender of the individual.
#* @param education_level The education level of the individual.
#* @param family_income The family income of the individual.
#* @param children_number The number of children in the individual's family.
#* @param province The province of the individual.
#* @post /predict_liberal_vote

function(age, gender, education_level, family_income, children_number, province) {
  # Convert parameters to the correct type
  age <- as.numeric(age)
  gender <- as.factor(gender)
  education_level <- as.factor(education_level)
  family_income <- as.numeric(family_income)
  children_number <- as.numeric(children_number)
  province <- as.factor(province)
  
  # Create a new data frame for prediction
  new_data <- data.frame(age = age,
                         gender = gender,
                         education_level = education_level,
                         family_income = family_income,
                         children_number = children_number,
                         province = province)
  
  # Make prediction using the `liberal_model`
  prediction <- predict(liberal_model, newdata = new_data, type = "response")
  
  # Return the prediction
  return(list(prediction = prediction))
}


plumb("05-model_api.R")$run(port=8000)
