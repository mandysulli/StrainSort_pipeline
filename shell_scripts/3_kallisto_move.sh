#!/bin/bash
#SBATCH --job-name=Kallisto_file_move
#SBATCH --partition=partition
#SBATCH --ntasks=1
#SBATCH --mem=#
#SBATCH --export=
#SBATCH --time=##:##:##
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=$$$$$$@email.edu
#SBATCH --mail-type=BEGIN,END,FAIL

##Moving the tsv files and pseudobam files to one location
##May need a fair amount of time for this. The bam files can be big.

#Set directory
cd /file/path/to/Kallisto_outputs

mkdir Kallisto_tsv_files
mkdir Kallisto_pseudobam_files

echo "$i"
mv ./Sample\/Sample_abundance.tsv ./Kallisto_tsv_files
mv ./Sample\/Sample\_pseudoalignments.bam ./Kallisto_pseudobam_files