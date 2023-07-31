# adding required libraries
# List of libraries
libraries <- c("data.table", "caret", "randomForest", "glmnet", "pROC")

# Use lapply to install and load each library
lapply(libraries, function(lib) {
   suppressPackageStartupMessages({
     if(!require(lib, character.only = TRUE)) {
       install.packages(lib)
     }
     library(lib, character.only = TRUE)
   })
})

