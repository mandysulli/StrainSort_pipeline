#!/bin/bash
#SBATCH --job-name=strain_file_setup
#SBATCH --partition=partition
#SBATCH --ntasks=1
#SBATCH --mem=#
#SBATCH --export=
#SBATCH --time=##:##:##
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=$$$$$$@email.edu
#SBATCH --mail-type=BEGIN,END,FAIL

module load Java/13.0.2

##Will need to make lineage folder with your strain_key.txt and lineage_file_setup.class file inside of it
##No spaces in the names

#Set directory to execute script
cd /scratch/mandyh/WISER_MC_Kallisto_Paper/lineage_files

java lineage_file_setup strain_key.txt
