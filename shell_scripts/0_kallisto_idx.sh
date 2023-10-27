#!/bin/bash
#SBATCH --job-name=Kallisto_indexing
#SBATCH --partition=partition
#SBATCH --ntasks=1
#SBATCH --mem=#
#SBATCH --export=
#SBATCH --time=##:##:##
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=$$$$$$@email.edu
#SBATCH --mail-type=BEGIN,END,FAIL

module load kallisto/0.48.0-gompi-2022a

#Set directory
cd /file/path/to/reference_sequences

kallisto index -i sequences.kallisto_idx ref_seqs.fasta