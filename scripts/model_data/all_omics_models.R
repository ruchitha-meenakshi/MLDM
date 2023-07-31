source("scripts/load_data/load_libraries.R"
load("RData_files/trainingdata.RData")
load("RData_files/preprocessed_training_datasets.RData")
load("RData_files/preprocessed_omics_datasets.RData")

# Access the "clinical" dataset from the list
clinical <- trainingdata$clinical
# Dropping 'pfi.time' column from the 'clinical' data frame
clinical <- subset(clinical, select = -c(pfi.time))

# For the clinical dataset
clinical <- data.frame(ID = rownames(clinical), clinical, row.names = NULL)

# For the omics datasets
for(i in names(omics_datasets)) {
  omics_datasets[[i]] <- data.frame(ID = rownames(omics_datasets[[i]]), omics_datasets[[i]],
                                    row.names = NULL)
}

# Set the seed for reproducibility
set.seed(123)

# Loop through each dataset for merging, partitioning, and model fitting
for(i in names(omics_datasets)) {

  # Merge only the common IDs between omic and clinical datasets
  merged_data <- merge(omics_datasets[[i]], clinical[c("ID", "pfi")], by = "ID", all = FALSE)

  # Determine the size of the dataset
  data_size <- nrow(merged_data)

  # Determine the size of the training set (70% of the total dataset)
  train_size <- round(0.70 * data_size)

  # Generate a random sample of row indices for the training set
  train_indices <- sample(seq_len(data_size), size = train_size)

  # Create the model matrix for the entire data set
  X_all <- model.matrix(pfi ~ ., data = merged_data)[,-1]

  # Then you can split the model matrix into training and test sets
  X_train <- X_all[train_indices, ]
  X_test <- X_all[-train_indices, ]

  # Extract the response variable
  y_train <- merged_data[train_indices, "pfi"]
  y_test <- merged_data[-train_indices, "pfi"]

  # Set up the grid of lambda values for cross-validation
  grid <- 10^seq(10, -2, length=100)
  cv.elnet <- cv.glmnet(X_train, y_train, family = "binomial", alpha = 0.5, lambda = grid)

  # The optimal lambda value
  lambda_optimal <- cv.elnet$lambda.min

  # Fit the model with the optimal lambda on the training data
  elnet.model <- glmnet(X_train, y_train, family = "binomial", alpha = 0.5, lambda = lambda_optimal)

  # Print the coefficients
  print(coef(elnet.model))

  # Get the model's predicted probabilities for the training data
  predicted_probs <- predict(elnet.model, newx = X_train, type = "response")

  # Compute the AUC
  roc_obj <- roc(y_train, predicted_probs)
  auc_val <- auc(roc_obj)

  # Print AUC
  print(auc_val)

  # Specify the directory and filename where the figure will be saved
  pdf(paste0("figures/all_omics_models/roc_curve_train_", i, ".pdf"))

  # Plot the ROC curve
  plot(roc_obj, main=paste0("ROC Curve (Training) for ", i))

  # Close the PDF device
  dev.off()

  # Get the model's predicted probabilities for the testing data
  predicted_probs_test <- predict(elnet.model, newx = X_test, type = "response")

  # Compute the AUC
  roc_obj_test <- roc(y_test, predicted_probs_test)
  auc_val_test <- auc(roc_obj_test)

  # Print AUC
  print(auc_val_test)

  # Specify the directory and filename where the figure will be saved
  pdf(paste0("figures/all_omics_models/roc_curve_test_", i, ".pdf"))

  # Plot the ROC curve
  plot(roc_obj_test, main=paste0("ROC Curve (Testing) for ", i))

  # Close the PDF device
  dev.off()
}

