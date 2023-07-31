source("scripts/load_data/load_libraries.R")
load("RData_files/trainingdata.RData")
load("RData_files/preprocessed_training_datasets.RData")

# Set the seed for reproducibility
set.seed(123)

# Access the "clinical" dataset from the list
clinical <- trainingdata$clinical
# Dropping 'pfi.time' column from the 'clinical' data frame
clinical <- subset(clinical, select = -c(pfi.time))

# Determine the size of the dataset
data_size <- nrow(clinical)
# Determine the size of the training set (70% of the total dataset)
train_size <- round(0.70 * data_size)

# Generate a random sample of row indices for the training set
train_indices <- sample(seq_len(data_size), size = train_size)

# Create the training set
training_set <- clinical[train_indices, ]

# Create the test set
testing_set <- clinical[-train_indices, ]

# `pfi` is the outcome variable we want to predict
X_train <- model.matrix(pfi ~ ., data = training_set)[,-1]  # predictors for training
y_train <- training_set$pfi  # response variable for training

X_test <- model.matrix(pfi ~ ., data = testing_set)[,-1]  # predictors for testing
y_test <- testing_set$pfi


# Set up the grid of lambda values for cross-validation, alpha is set to 0.5 for elastic net
grid <- 10^seq(10, -2, length=100)
cv.elnet <- cv.glmnet(X_train, y_train, family = "binomial", alpha = 0.5, lambda = grid)

# The optimal lambda value is stored in `cv.elnet$lambda.min`
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
pdf("figures/roc_curve.pdf")

# Plot the ROC curve
plot(roc_obj, main="ROC Curve")

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
pdf("figures/roc_curve_test.pdf")

# Plot the ROC curve
plot(roc_obj_test, main="ROC Curve")

# Close the PDF device
dev.off()


