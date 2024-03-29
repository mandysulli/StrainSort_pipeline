#!/bin/bash
#SBATCH --job-name=spades_strain_specific
#SBATCH --partition=partition
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=##
#SBATCH --export=
#SBATCH --time=##:##:##
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=$$$$$$@email.edu
#SBATCH --mail-type=BEGIN,END,FAIL

module load SPAdes/3.15.5-GCC-11.3.0 

mkdir /file/path/to/spades_outputs

cd /file/path/to/spades_outputs

input='/file/path/to/variant_specific_reads_fastq'

### Get the strains used for x from the "All_strain_names.txt" file created by lineage_file_stepup.class
### add unmapped to end
### here the flag meta is being used. You can use corona for SARS-CoV-2 data
### make sure threads and memory match the resources given
### Spades will output a folder with assembly files within it
for x in {strain1,strain2,strain3,unmapped}
do
python /file/path/to/spades.py --meta --threads 8 --memory 5 --only-assembler -o ./Sample -1 $input/Sample_$x\_R1.fastq -2 $input/Sample_$x\_R2.fastq
done