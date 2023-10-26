#!/bin/bash
#SBATCH --job-name=Kallisto_quant_psuedobam
#SBATCH --partition=partition
#SBATCH --ntasks=#
#SBATCH --cpus-per-task=#
#SBATCH --mem=#
#SBATCH --export=
#SBATCH --time=##:##:##
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=$$$$$$@email.edu
#SBATCH --mail-type=BEGIN,END,FAIL

##This can take a fair amount of memory and time

module load SAMtools/1.14-GCC-11.2.0

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

### only grab mapped reads where both R1 and R2 map
cat $input/Sample_pseudoalignments.sam | grep -v "^@" | awk 'BEGIN{FS="\t";OFS="\t"}{if($2=='83'||$2=='99'||$2=='147'||$2=='163') print $0}' > $output/incomplete_Sample_mapped_reads.sam
cat $input/Sample_pseudoalignments.sam | grep -v "^@" | awk 'BEGIN{FS="\t";OFS="\t"}{if($2=='77'||$2=='141') print $0}' > $output/incomplete_Sample_unmapped_reads.sam
cat $output/sam_headers_Sample.txt $output/incomplete_Sample_unmapped_reads.sam > $output/Sample_unmapped_reads.sam
samtools view -S -b $output/Sample_unmapped_reads.sam > $output/Sample_unmapped_reads.bam
samtools fastq $output/Sample_unmapped_reads.bam -1 $output2/Sample_unmapped_R1.fastq -2 $output2/Sample_unmapped_R2.fastq

### Pulling out lineage from mapped reads by sample
### Get the strain used for x from the "All_strain_names.txt" file created in previous set
for x in {strain1,strain2,strain3}
do
grep -f $lineage/$x\.txt $output/incomplete_Sample_mapped_reads.sam > $output/incomplete_Sample_$x\_reads.sam
cat $output/sam_headers_Sample.txt $output/incomplete_Sample_$x\_reads.sam > $output/Sample_$x\_reads.sam
samtools view -S -b $output/Sample_$x\_reads.sam > $output/Sample_$x\_reads.bam
echo "$x"
samtools fastq $output/Sample_$x\_reads.bam -1 $output2/Sample_$x\_R1.fastq -2 $output2/Sample_$x\_R2.fastq
done