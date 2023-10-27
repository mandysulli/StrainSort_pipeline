#!/bin/bash
#SBATCH --job-name=mafft
#SBATCH --partition=highmem_p
#SBATCH --ntasks=#
#SBATCH --cpus-per-task=#
#SBATCH --mem=#
#SBATCH --export=
#SBATCH --time=##:##:##
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=$$$$$$@email.edu
#SBATCH --mail-type=BEGIN,END,FAIL

module load MAFFT/7.505-GCC-11.3.0-with-extensions

cd /file/path/to/mafft_inputs

#define directory
output='/file/path/to/mafft_outputs'

mafft --globalpair --maxiterate Sample_final.fasta > $output/Sample.fasta