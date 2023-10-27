#!/bin/bash
#SBATCH --job-name=Extract_region_of_interest
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

#set directory
cd /file/path/to/spades_alignment_ref

#make directory
mkdir /file/path/to/extracted_spike_fastas

#define directory
output='/file/path/to/extracted_spike_fastas'


### Get the strain used for x from the "All_strain_names.txt" file created in previous set
### add unmapped to end
### will have to have scaffold_joining.class in the folder where the scaffold to ref alignments are 
### for scaffold_joining program to work you need to provide the sam file first, then the starting position of your regions of interesting, then the ending position of your region of interest and finally the size of the reference sequence being used
### output files from scaffold_joining program will be named Extracted_(name_of_file_given).fasta

for x in {strain1,strain2,strain3,unmapped}
do
java scaffold_joining Sample_$x\.sam 21563 25384 29903
mv ./Extracted_Sample_$x\.fasta $output
done