#!/bin/bash
# @job_name = create_alleles
# @initialdir = .
# @output = all.out
# @error = all.err
# @total_tasks = 4
# @wall_clock_limit = 15:00:00

module purge
module unload gcc
module load gcc/6.3.0
module load xz/5.2.2
module load java
module load TABIX/0.2.6
module load BCFTOOLS

PANEL=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.1_analysis_chimp/PANEL/

#MAIN SCRIPT

bcftools query -f'%CHROM\t%POS\t%REF,%ALT\n' ${PANEL}filtered_chimp_chr21_Panel.vcf.gz | bgzip -c > ${PANEL}als.tsv.gz && tabix -s1 -b2 -e2 ${PANEL}als.tsv.gz;

