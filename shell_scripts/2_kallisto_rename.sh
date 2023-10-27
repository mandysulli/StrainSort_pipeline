#!/bin/bash
#SBATCH --job-name=Kallisto_file_rename
#SBATCH --partition=partition
#SBATCH --ntasks=1
#SBATCH --mem=#
#SBATCH --export=
#SBATCH --time=##:##:##
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=$$$$$$@email.edu
#SBATCH --mail-type=BEGIN,END,FAIL

# we are renaming the files to have the sample name at the front of them

#Set directory
cd /file/path/to/Kallisto_outputs

echo "$i"
mv ./Sample\/abundance.h5 ./Sample\/Sample\_abundance.h5
mv ./Sample\/abundance.tsv ./Sample\/Sample\_abundance.tsv
mv ./Sample\/run_info.json ./Sample\/Sample\_run_info.json
mv ./Sample\/pseudoalignments.bam ./Sample\/Sample\_pseudoalignments.bam