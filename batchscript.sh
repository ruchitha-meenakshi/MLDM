#!/bin/bash
#SBATCH --job-name=mldm_assessment
#SBATCH --partition=cpu
#SBATCH --account=sscm027704
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --time=10-00:0:0
#SBATCH --mem=20G
#SBATCH --output=results/slurm-%j.out
echo 'MLDM Assessment'

module add languages/r/4.2.1

cd "${SLURM_SUBMIT_DIR}"

date
# loading the data and preprocessing steps
Rscript --vanilla scripts/load_data.R 
date
