#### Preamble ####
# Purpose: Downloads and saves the data from Harvard Dataverse
# Author: Yichen Ji
# Date: 09 March 2024
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites: downloading the packages "rvest" and "httr"
# Any other information needed? No.


#### Workspace setup ####
library(rvest)
library(httr)

#### Download data ####
download_url_survey <- "https://dataverse.harvard.edu/api/access/datafile/7517836"
destifile_survey <- "data/raw_data/2021survey.tab"
GET(download_url_survey,write_disk(destifile_survey,overwrite = TRUE))


