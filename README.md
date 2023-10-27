# StrainSort_pipeline
 The StrainSort pipeline was created for use with complex mutl-strain samples. StrainSort can identify the strains within you sample, estimate the abundance of each strain within the sample and perform phylogenetic analysis of the strains present. 


WORKFLOW:

<img width="468" alt="image" src="https://github.com/mandysulli/StrainSort_pipeline/assets/89869003/5e27777f-91fc-4582-ac08-99d0bc05f3a9">


Inputs Needed:
1. Paired end FASTQ-Formatted sequencing reads (of any length) obtained from a sample(s) of interest
2. Compiled reference genomes or sequences (such as scaffolds) as a reference database
3. A strain key - must have the headers of the reference seuqences in the first column and the strain associated with that sequnce in the second column. Other data can be present.
4. A single reference genome from the species of interest 
