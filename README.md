# StrainSort_pipeline
 The StrainSort pipeline was created for use with complex mutl-strain samples. StrainSort can identify the strains within you sample, estimate the abundance of each strain within the sample and perform phylogenetic analysis of the strains present. 


## WORKFLOW:

<img width="468" alt="image" src="https://github.com/mandysulli/StrainSort_pipeline/assets/89869003/5e27777f-91fc-4582-ac08-99d0bc05f3a9">


Notes:

scripts can be downloaded from "shell_scripts"
Compiled Java program can be downloaded from "java_programs_compiled" - Programs compled with Java/13.0.2
Java programs that have not been compiled can be downloaded from "java_programs_not_compiled" - can be compled with any version of java using:
javac program_name.java


Inputs Needed:
1. Paired end FASTQ-Formatted sequencing reads (of any length) obtained from a sample(s) of interest
2. Compiled reference genomes or sequences (such as scaffolds) as a reference database
3. A strain key - must have the headers of the reference seuqences in the first column and the strain associated with that sequnce in the second column. Other data can be present.
4. A single reference genome from the species of interest 


## Step 1: Strain abundance estimation and read assignment:

Run with kallisto

Inputs needed here:
Paired end reads - they can be any read length
An index reference database - run script 0_kallisto_idx.sh with your reference sequences concatinated into one file

```
kallisto quant -t 6 -b 100 --pseudobam -i $index/sequences.kallisto_idx -o $output/Sample $input/Sample_pair_trim_R1.fastq.gz $input/Sample_pair_trim_R2.fastq.gz
```

Outputs:
a tsv file with the estimated counts of reads per reference sequence
a pseudobam file that indicates which reference sequence each reads pseudoaligned with

**Will need to rename and move outputs**
rename
```
mv ./Sample\/abundance.tsv ./Sample\/Sample\_abundance.tsv
mv ./Sample\/pseudoalignments.bam ./Sample\/Sample\_pseudoalignments.bam
```
move
```
#Set directory
cd /file/path/to/Kallisto_outputs

mkdir Kallisto_tsv_files
mkdir Kallisto_pseudobam_files

echo "$i"
mv ./Sample\/Sample_abundance.tsv ./Kallisto_tsv_files
mv ./Sample\/Sample_pseudoalignments.bam ./Kallisto_pseudobam_files
```

Vizualization can be made from tsv file using the Rmarkdown file:

## Step 2: Sepparation of reads based on strain mapping:

Run with SAMtools

Inputs needed:
strain_key.txt - This will need to be a tab delimited text file. This first column will need to have the headers from the reference seqeunces that you used in your reference database and the second colomn will need to have the strain associated with the header. There can be other meta data in the file, however these need to be the first two coloumns. 

**Before separation, you will need to set up the strain files**
Will need to make lineage folder with your strain_key.txt and lineage_file_setup.class file inside of it

```
cd /scratch/mandyh/WISER_MC_Kallisto_Paper/lineage_files

java lineage_file_setup strain_key.txt
```
