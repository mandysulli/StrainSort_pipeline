#!/bin/bash
#SBATCH --job-name=Combine_filter
#SBATCH --partition=iob_p
#SBATCH --ntasks=1
#SBATCH --mem=25gb
#SBATCH --export=NONE
#SBATCH --time=4:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=mandyh@uga.edu
#SBATCH --mail-type=BEGIN,END,FAIL

module load Java/13.0.2

## this script combines all the spike protein regions from each lineage by sample
## then the java program removes sequences that have N's that make up more than half of the region of interest
## files that are output are named: $input$file$name$_final.fasta

inputs='/file/path/to/extracted_spike_fastas'

cd /file/path/to/mafft_inputs


cat $inputs/Sample_*.fasta > Sample_spike_proteins.fasta 
java fasta_all_n_filter_v2 Sample_spike_proteins.fasta 
