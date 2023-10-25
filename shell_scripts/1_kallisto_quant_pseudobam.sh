#!/bin/bash
#SBATCH --job-name=Kallisto_quant_psuedobam
#SBATCH --partition=partition
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=#
#SBATCH --export=
#SBATCH --time=##:##:##
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=$$$$$$@email.edu
#SBATCH --mail-type=BEGIN,END,FAIL

##kallisto will make output folders for each sample containing these files: abundance.h5, abundance.tsv, run_info.json and pseudoalignments.bam

module load kallisto/0.48.0-gompi-2022a

#Set directory
cd /file/path/to/working/directory

#define directory
index='/file/path/to/indexed_ref_database/'
input='/file/path/to//paired_trim_reads'
output='/file/path/to/Kallisto_outputs'


kallisto quant -t 6 -b 100 --pseudobam -i $index/sequences.kallisto_idx -o $output/Sample $input/Sample_pair_trim_R1.fastq.gz $input/Sample_pair_trim_R2.fastq.gz