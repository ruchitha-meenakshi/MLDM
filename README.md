# Research Question: Predicting Progression-Free Interval in Cancer using Multi-Omics Data

## Overview

In this study, we aim to develop a set of models for predicting the progression-free interval (PFI) in cancer patients using multi-omics data. The multi-omics data consist of genomic, transcriptomic, proteomic, epigenomic, and clinical data from a cohort of cancer patients.

Our approach is to build individual predictive models for each omics data type, identify the top predictors in each model, and then use these predictors to build an ensemble model for prediction.

## Methodology

1. **Data Loading**: We load the multi-omics data from the specified directories. The data should be tab-delimited files where each file represents a different omics data type (except CNV data which we ignore in this study). Each data file is processed to remove duplicate rows based on the first column, and the first column is set as the row names of the data frame. 

2. **Feature Selection**: For each data type, we eliminate features with no variance or with all missing values.  

3. **Model Building**: We fit an elastic net model to the top predictors identified in the feature selection step for each omics data type. The models are stored for later use in prediction.

4. **Prediction and Evaluation**: For the test dataset, we use the same processing steps as the training data, and apply the trained models to make predictions. The performance of the models is evaluated using the area under the receiver operating characteristic (ROC) curve (AUC).

## Requirements

The scripts are written in R and require the following packages:

- `data.table`: for efficient data loading and manipulation
- `limma`: for identifying top predictors in each omics data type
- `glmnet`: for fitting the elastic net models
- `pROC`: for computing the area under the ROC curve

## Running the scripts

Please replace the following placeholders at the top of the script with your actual directory paths:

```R
training.dir <- ...  # Directory containing the training data
testing.dir <- ...   # Directory containing the testing data
```

After replacing the directory paths, you can run the script in an R environment.

## Caveats and Assumptions

The script assumes that the multi-omics data are preprocessed and normalized appropriately. The outcome variable is assumed to be binary (progression-free or not).

## Future Directions

This study is a step towards a more comprehensive multi-omics integration for predicting cancer progression. Future improvements could include incorporating CNV data and using other types of machine learning models such as random forests, support vector machines, or deep learning methods. Combining predictions from individual models in a more sophisticated way, such as stacking or voting, could potentially improve prediction performance.
