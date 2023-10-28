# StrainSort_pipeline
 The StrainSort pipeline was created for use with complex mutl-strain samples. StrainSort can identify the strains within you sample, estimate the abundance of each strain within the sample and perform phylogenetic analysis of the strains present. 


## WORKFLOW:

<img width="500" alt="image" src="https://github.com/mandysulli/StrainSort_pipeline/assets/89869003/5e27777f-91fc-4582-ac08-99d0bc05f3a9">


Notes:

scripts can be downloaded from "shell_scripts"
Compiled Java program can be downloaded from "java_programs_compiled" - Programs compled with Java/13.0.2
Java programs that have not been compiled can be downloaded from "java_programs_not_compiled" - can be compled with any version of java using:
javac program_name.java


Inputs required:
1. Paired end FASTQ-Formatted sequencing reads (of any length) obtained from a sample(s) of interest
2. Compiled reference genomes or sequences (such as scaffolds) as a reference database
3. A strain key - must have the headers of the reference seuqences in the first column and the strain associated with that sequnce in the second column. Other data can be present.
4. A single reference genome from the species of interest 


## Step 1: Strain abundance estimation and read assignment:

Run with kallisto

Inputs required here:
1. Paired end reads - they can be any read length
2. An index reference database - run script 0_kallisto_idx.sh with your reference sequences concatinated into one file

```
cd /file/path/to/Kallisto_outputs
kallisto quant -t 6 -b 100 --pseudobam -i $index/sequences.kallisto_idx -o $output/Sample $input/Sample_pair_trim_R1.fastq.gz $input/Sample_pair_trim_R2.fastq.gz
```

Outputs:
1. A tsv file with the estimated counts of reads per reference sequence
2. A pseudobam file that indicates which reference sequence each reads pseudoaligned with

**Will need to rename and move outputs**
rename
```
cd /file/path/to/Kallisto_outputs
mv ./Sample\/abundance.tsv ./Sample\/Sample\_abundance.tsv
mv ./Sample\/pseudoalignments.bam ./Sample\/Sample\_pseudoalignments.bam
```
move
```
cd /file/path/to/Kallisto_outputs
mkdir Kallisto_tsv_files
mkdir Kallisto_pseudobam_files

echo "$i"
mv ./Sample\/Sample_abundance.tsv ./Kallisto_tsv_files
mv ./Sample\/Sample_pseudoalignments.bam ./Kallisto_pseudobam_files
```

Vizualization can be made from tsv file using the Rmarkdown file:

## Step 2: Sepparation of reads based on strain mapping:

Inputs required here:
1. strain_key.txt - This will need to be a tab delimited text file. This first column will need to have the headers from the reference seqeunces that you used in your reference database and the second colomn will need to have the strain associated with the header. There can be other meta data in the file, however these need to be the first two coloumns. 

**Before separation, you will need to set up the strain files**

Will need to make lineage folder with your strain_key.txt and lineage_file_setup.class file inside of it

```
cd /scratch/mandyh/WISER_MC_Kallisto_Paper/lineage_files

java lineage_file_setup strain_key.txt
```
Run with SAMtools

```
#Set directory
cd /file/path/to/Kallisto_outputs

##Create directories
mkdir /file/path/to/variant_specific_reads_alignments
mkdir /file/path/to/variant_specific_reads_fastq

#define directory
input='/file/path/to/Kallisto_outputs/Kallisto_pseudobam_files'
output='/file/path/to/variant_specific_reads_alignments'
output2='/file/path/to/variant_specific_reads_fastq'
lineage='/file/path/to/lineage_files'

##converting to pseudobam to sam to work with
samtools sort $input/Sample_pseudoalignments.bam > $input/Sample_pseudoalignments_sorted.bam
samtools index $input/Sample_pseudoalignments_sorted.bam
samtools view -h $input/Sample_pseudoalignments_sorted.bam > $input/Sample_pseudoalignments.sam
grep "@" $input/Sample_pseudoalignments.sam > $output/sam_headers_Sample.txt

### only grab mapped reads where both R1 and R2 map - need paired for spades to work
cat $input/Sample_pseudoalignments.sam | grep -v "^@" | awk 'BEGIN{FS="\t";OFS="\t"}{if($2=='83'||$2=='99'||$2=='147'||$2=='163') print $0}' > $output/incomplete_Sample_mapped_reads.sam
### grab unmapped reads
cat $input/Sample_pseudoalignments.sam | grep -v "^@" | awk 'BEGIN{FS="\t";OFS="\t"}{if($2=='77'||$2=='141') print $0}' > $output/incomplete_Sample_unmapped_reads.sam
cat $output/sam_headers_Sample.txt $output/incomplete_Sample_unmapped_reads.sam > $output/Sample_unmapped_reads.sam
samtools view -S -b $output/Sample_unmapped_reads.sam > $output/Sample_unmapped_reads.bam
samtools fastq $output/Sample_unmapped_reads.bam -1 $output2/Sample_unmapped_R1.fastq -2 $output2/Sample_unmapped_R2.fastq

### Pulling out lineage from mapped reads by sample
### Get the strains used for x from the "All_strain_names.txt" file created by lineage_file_stepup.class
for x in {strain1,strain2,strain3}
do
grep -f $lineage/$x\.txt $output/incomplete_Sample_mapped_reads.sam > $output/incomplete_Sample_$x\_reads.sam
cat $output/sam_headers_Sample.txt $output/incomplete_Sample_$x\_reads.sam > $output/Sample_$x\_reads.sam
samtools view -S -b $output/Sample_$x\_reads.sam > $output/Sample_$x\_reads.bam
echo "$x"
samtools fastq $output/Sample_$x\_reads.bam -1 $output2/Sample_$x\_R1.fastq -2 $output2/Sample_$x\_R2.fastq
done
```

## Step 3: _de novo_ asseembly of reads by strain

Run with SPAdes

Things to note at this step:
1. Get the strains used for x from the "All_strain_names.txt" file created by lineage_file_stepup.class and add unmapped to end
2. Here the flag meta is being used. You can use corona for SARS-CoV-2 data
3. Make sure threads and memory match the resources given
4. Spades will output a folder with assembly files within it

```
mkdir /file/path/to/spades_outputs
cd /file/path/to/spades_outputs
python /file/path/to/spades.py --meta --threads 8 --memory 5 --only-assembler -o ./Sample -1 $input/Sample_$x\_R1.fastq -2 $input/Sample_$x\_R2.fastq
```

## Step 4: Extract region of interest from the assembled scaffolds

Inputs required here:
1. A reference genome to be used as an anchor for extracting the region of interest 

**Before extracting the scaffolds from the SPAdes assembly will need to be mapped to a reference genome**


