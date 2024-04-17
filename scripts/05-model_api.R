
# 加载必要的库
library(plumber)
library(rstanarm)

# 读取模型，这里假设模型文件在当前目录
liberal_model <- readRDS("../models/liberal_model.rds")

#* @apiTitle Liberal Vote Prediction API
#* @apiDescription This API predicts the probability of voting for the Liberal Party based on the model.
#* @param age numeric The age of the individual.
#* @param gender character The gender of the individual.
#* @param education_level character The education level of the individual.
#* @param family_income numeric The family income of the individual.
#* @param children_number numeric The number of children in the individual's family.
#* @param province character The province of the individual.
#* @post /predict_liberal_vote
function(age, gender, education_level, family_income, children_number, province) {
  
  # 确保输入参数是正确的类型
  age <- as.numeric(age)
  gender <- as.factor(gender)
  education_level <- as.factor(education_level)
  family_income <- as.numeric(family_income)
  children_number <- as.numeric(children_number)
  province <- as.factor(province)
  
  # 创建一个新的数据框架进行预测
  new_data <- data.frame(age = age,
                         gender = gender,
                         education_level = education_level,
                         family_income = family_income,
                         children_number = children_number,
                         province = province)
  
  # 使用模型进行预测
  prediction <- posterior_predict(liberal_model, newdata = new_data)
  
  # 返回预测结果
  return(list(prediction = prediction))
}

# 创建一个plumber API
pr <- plumb("05-model_api.R") # 假设这是你的脚本文件名
pr$run(port=8000)
