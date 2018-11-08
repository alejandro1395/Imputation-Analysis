# Impute_Master_Thesis

Here there is a pipeline of bioinformatics software in order to study the effectivenessof Haplotype Imputation from LOW-COVERAGE
samples in great-apes data. The scripts loop for different individuals belonging to the 4 subspecies of chimpanzee in this
case:5a

STEP 1 -> MAPPING to the human genome and sorting the files

STEP2-> Merging and removing duplicates from our samples

STEP3-> Get coverage and Downsamples our files (to evaluate the method), in a normal case this STEP would be skipped

STEP4-> Call variants from bam file

STEP5-> Prepare Input files:
5a) Files for recombinations map:
- Fetch recombination map and convert units to cM for the imputation software
- Lift over genome coordinates to have the proper reference in all files

5b) Prepare GEN file

5c) Prepare PANEL file

6) RUN with chunks for different regions of the chromosomes the IMPUTE2 software

7) OBTAIN OUTPUT and parse to the desired format

8) Get VCF and compare with the previous file before downsampling
