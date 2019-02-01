#!/bin/bash

# @job_name = filtering_chr21
# @initialdir = .
# @output = filtering.out
# @error = filtering.err
# @total_tasks = 4
# @wall_clock_limit = 15:00:00


module unload gcc
module unload VCFTOOLS
module load gcc/4.9.3-gold
module load zlib/1.2.8  
module load HTSLIB/latest
module load VCFTOOLS/0.1.12

vcftools --remove-indels --min-alleles 2 --max-alleles 2 --mac 2 --max-missing 0.99 \
--keep chimp_samples --gzvcf /home/devel/marcmont/scratch/GA/GATK/JOINT/chr21/GA.chr21.144combined.vcf.gz \
--recode --stdout | bgzip -c > /scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.1_analysis_chimp/PANEL/filtered_chimp_chr21_Panel.vcf.gz
