#!/bin/bash
#SBATCH --job-name=mldm_assessment
#SBATCH --partition=cpu
#SBATCH --account=sscm027704
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --time=10-00:0:0
#SBATCH --mem=20G
#SBATCH --output=results/clinical_model/slurm-%j.out
echo 'MLDM Assessment - Clinical Model'

module add languages/r/4.2.1

cd "${SLURM_SUBMIT_DIR}"

date
# loading the data and preprocessing steps
Rscript --vanilla scripts/load_data/load_libraries.R
echo 'completed loading libraries'
Rscript --vanilla scripts/load_data/read_table.R
Rscript --vanilla scripts/load_data/load_traindata.R 
echo 'completed loading training data'
Rscript --vanilla scripts/preprocessing_data/preprocessing_traindata.R
echo 'completed preprocessing training data'
Rscript --vanilla scripts/model_data/clinical_model.R
echo 'completed building the clinical_model'
date
