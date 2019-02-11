#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#BAM OUTPUT
DATA=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/results/HUMAN_TEST/1000Gfiles/data/
OUTDIR=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_human/REF/

#MAIN SCRIPT LOOPED FOR 3 CHIMPS

mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR}qu/
mkdir -p ${OUTDIR}out/

module purge
module unload gcc
module load gcc/6.3.0
module load xz/5.2.2
module load java
module load TABIX/0.2.6
module load BCFTOOLS

bcftools view --type snps --max-alleles 2 -c 2 \
-s ^HG03977,HG03978,HG03985,HG03986,HG03989,HG03990,HG03991,HG03995,HG03998,HG03999 \
${DATA}ALL.chr20.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz | bgzip -c > ${OUTDIR}filtered_1000G_panel.vcf;
tabix -p vcf ${OUTDIR}filtered_1000G_panel.vcf
