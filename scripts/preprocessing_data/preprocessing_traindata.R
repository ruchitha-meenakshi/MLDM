source("scripts/load_data/load_libraries.R")
load("RData_files/trainingdata.RData")

# Create a list to hold all training datasets
trainingdata = list(clinical = clinical, methylation = methylation, mirna = mirna,
                    mrna = mrna, mutation = mutation, protein = protein)
# Identifying and removing the zero variance features from the training datasets
zero.var.features <- list()
# Loop over the list and identify zero-variance predictors
for(i in names(trainingdata)) {
  zero.var.features[[i]] <- nearZeroVar(trainingdata[[i]], saveMetrics= TRUE)
  # Print the zero variance features
  print(paste("Zero variance features for", i))
  
  # Identify zero variance features
  zero_var_names <- rownames(zero.var.features[[i]][zero.var.features[[i]]$zeroVar == TRUE, ])
  
  # Remove zero variance features from the dataset
  trainingdata[[i]] <- trainingdata[[i]][, !names(trainingdata[[i]]) %in% zero_var_names]
}

# List of variables to convert to factors
vars_to_factor <- c("histology", "estrogen.receptor.status", "progesterone.receptor.status",
                    "her2.status", "ethnicity", "race", "stage", "tnm.m.category",
                    "tnm.n.category", "tnm.t.category", "pfi")

# Convert variables to factors
for (var in vars_to_factor) {
  clinical[[var]] <- as.factor(clinical[[var]])
}

# Update the list with the modified clinical data frame
trainingdata$clinical <- clinical

# Missing Values
# Loop over the list and print the sum of missing values for each dataset
for (i in names(trainingdata)) {
  missing_values <- sum(is.na(trainingdata[[i]]))
  print(paste("Number of missing values for", i, ":", missing_values))
}

# applying na.roughfix() for median/mode imputation for missing values in the datasets
# Loop over datasets and apply na.roughfix
for(i in names(trainingdata)) {
  trainingdata[[i]] <- na.roughfix(trainingdata[[i]])
}

# List of omics datasets
omics_datasets <- list(mirna = trainingdata$mirna,
                       methylation = trainingdata$methylation,
                       mrna = trainingdata$mrna,
                       mutation = trainingdata$mutation,
                       protein = trainingdata$protein)
# Original dimensions
for(i in names(omics_datasets)) {
  cat(i, "Original: ", dim(omics_datasets[[i]]), "\n")
}

# Loop through the list and standardize each dataset
for(i in names(omics_datasets)) {
  # Check if all columns in data frame are numeric
  if(all(sapply(omics_datasets[[i]], is.numeric))) {
    # Standardize
    omics_datasets[[i]] <- scale(omics_datasets[[i]])
  }
}

for(i in names(omics_datasets)) {
  # Transpose the numeric data
  omics_datasets[[i]] <- t(omics_datasets[[i]])
  # Convert the matrix to a data frame
  omics_datasets[[i]] = as.data.frame(omics_datasets[[i]])
}

# Transposed dimensions
for(i in names(omics_datasets)) {
  cat(i, "Transposed: ", dim(omics_datasets[[i]]), "\n")
}

# Save all the preprocessed datasets
save(trainingdata, file = "RData_files/preprocessed_training_datasets.RData")

# Save the omics datasets
save(omics_datasets, file = "RData_files/preprocessed_omics_datasets.RData")

# Save the omics datasets
save(datasets, file = "RData_files/preprocessed_training_datasets.RData")



