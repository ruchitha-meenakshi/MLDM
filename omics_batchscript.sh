#!/bin/bash
#SBATCH --job-name=mldm_assessment
#SBATCH --partition=cpu
#SBATCH --account=sscm027704
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --time=10-00:0:0
#SBATCH --mem=20G
#SBATCH --output=results/all_omics_models/slurm-%j.out
echo 'MLDM Assessment'

module add languages/r/4.2.1

cd "${SLURM_SUBMIT_DIR}"

date
# loading the data and preprocessing steps
Rscript --vanilla scripts/load_data/load_libraries.R
echo 'completed loading libraries'
Rscript --vanilla scripts/load_data/read_table.R
Rscript --vanilla scripts/load_data/load_traindata.R
echo 'completed loading training data'
Rscript --vanilla scripts/load_data/load_testdata.R
echo 'completed loading testing data'
Rscript --vanilla scripts/preprocessing_data/preprocessing_traindata.R
#echo 'completed preprocessing training data'
Rscript --vanilla scripts/preprocessing_data/preprocessing_testdata.R
echo 'completed preprocessing testing data'
#Rscript --vanilla scripts/preprocessing_data/setdiff.R
#echo 'finding set diff'
#Rscript --vanilla scripts/model_data/all_omics_models.R
#echo 'completed building the omics_models'
Rscript --vanilla scripts/model_data/check_omics_clinical.R
date
