#!/bin/bash
#SBATCH --job-name=spades_assembly_mapping_ref
#SBATCH --partition=partition
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=#
#SBATCH --mem=#
#SBATCH --export=
#SBATCH --time=##:##:##
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=$$$$$$@email.edu
#SBATCH --mail-type=BEGIN,END,FAIL

module load BBMap/39.01-GCC-11.3.0
module load Java/11.0.16

cd /file/path/to/spades_outputs

#define directory
ref='/file/path/to/ref_genomes'
output='/file/path/to/spades_alignment_ref'

### Get the strain used for x from the "All_strain_names.txt" file created by lineage_file_stepup.class
### add unmapped to end
## ref genome indexed
## bbmap maps scaffolds to genome
for x in {strain1,strain2,strain3,unmapped}
do
bbmap.sh in=./Sample_$x\/scaffolds.fasta out=$output/Sample_$x\.sam ref=$ref/reference_genome.fasta
done