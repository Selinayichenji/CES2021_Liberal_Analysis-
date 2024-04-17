#### Preamble ####
# Purpose: Set package lintr to check code
# Author: Yichen Ji
# Date: 27 March 2024
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites:NA
# Any other information needed? None


#install.packages("lintr")

library(lintr)

# Lint through all the scripts in the current directory
lint_dir(path = ".")
