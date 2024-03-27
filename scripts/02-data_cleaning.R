#### Preamble ####
# Purpose: Transform data from tab file into parquet file and filter esstential columns and individuals
# Author: Yichen Ji
# Date: 09 March 2024
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download tidyverse package
# Any other information needed? No.

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Clean data ####
survey_data <- read.delim("data/raw_data/2021survey.tab")

survey_data <- 
  survey_data %>% 
  mutate(age = case_when(cps21_age >= 18 & cps21_age <= 29 ~ "18-29",
                         cps21_age >= 30 & cps21_age <= 44 ~ "30-44",
                         cps21_age >= 45 & cps21_age <= 59 ~ "45-59",
                         cps21_age>= 60 & cps21_age <= 74 ~ "60-74",
                         cps21_age > 74 ~ "75+"),
         vote_liberal = ifelse(cps21_votechoice==1, 1, 0),
         vote_conservative = ifelse(cps21_votechoice==2, 1, 0),
         vote_NDP = ifelse(cps21_votechoice == 3, 1, 0),
         gender = case_when(cps21_genderid == 1 ~ "Male",
                            cps21_genderid == 2 ~ "Female"), 
         education_level = case_when(cps21_education %in% c(1,2,3,4) ~ "Less than high school", 
                                     #Less than high school diploma or its equivalent
                                     cps21_education %in% c(5,6)  ~ "High school",
                                     #High school diploma or a high school equivalency certificate
                                     cps21_education == 7 ~ "Non-University", 
                                     #Completed technical, community college, CEGEP, College Classique
                                     cps21_education == 8 ~ "University certificate below the bachelor", 
                                     #University certificate or diploma below the bachelor's level
                                     cps21_education == 9 ~ "Bachelor's degree", 
                                     cps21_education %in% c(10,11) ~ "Above the bachelor"),
         # University certificate, diploma or degree above the bachelor
         family_income = cut(cps21_income_number, breaks = c(0, 24999, 49999, 74999, 99999, 124999, Inf), 
                             labels = c("Less than $25,000", "$25,000 to $49,999", "$50,000 to $74,999", "$75,000 to $99,999",
                                        "$100,000 to $124,999", "$125,000 and more")), 
         province = case_when(cps21_province == 1 ~ "Alberta",
                              cps21_province == 2 ~ "British Columbia",
                              cps21_province == 3 ~ "Manitoba",
                              cps21_province == 4 ~ "New Brunswick",
                              cps21_province == 5 ~ "Newfoundland and Labrador",
                              #cps21_province == 6 ~ "Northwest Territories",
                              cps21_province == 7 ~ "Nova Scotia",
                              #cps21_province %in% c(8,13) ~ "Yukon / Northwest Territories / Nunavut",
                              cps21_province == 9 ~ "Ontario",
                              cps21_province == 10 ~ "Prince Edward Island",
                              cps21_province == 12 ~ "Saskatchewan"),
         children_number = case_when(cps21_children == 1 ~ "0",
                                     cps21_children == 2 ~ "1",
                                     cps21_children == 3 ~ "2",
                                     cps21_children == 4 ~ "3",
                                     cps21_children == 5 ~ "4",
                                     cps21_children == 6 ~ "4+"))%>%
  filter(!(vote_liberal == 0 & vote_conservative == 0 & vote_NDP == 0))%>%
  select(age,vote_liberal, vote_conservative, vote_NDP, gender, education_level, family_income, province, children_number) %>%
  filter(age >= 18) %>% 
  filter(!is.na(gender)) %>%
  filter(!is.na(family_income))%>%
  filter(!is.na(vote_liberal))%>%
  filter(!is.na(vote_conservative))%>%
  filter(!is.na(vote_NDP))%>%
  filter(!is.na(education_level))%>%
  filter(!is.na(province))%>%
  filter(!is.na(children_number))

write_parquet(survey_data, "data/analysis_data/analysis_data.parquet")
