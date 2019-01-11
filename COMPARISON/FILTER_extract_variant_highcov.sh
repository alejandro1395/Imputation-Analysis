#!/usr/bin/bash

module load gcc/4.9.3-gold
module load PYTHON/3.6.3
#VARIABLES
chimp_names="verus-McVean"
chromosomes="22"

#OUTDIR FOR ANALYZING HIGH COVERAGE INDIVIDUAL VCFs

OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/results/Comparison/"

#INPUTS for chr
DATA="/home/devel/marcmont/scratch/GA/GATK/JOINT/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/src/COMPARISON/"

echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}

echo $chromosomes | tr " " "\n" | while read chr;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/out/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/qu/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/tmp/
INPUT2=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/PANEL_REF/chr22/filtered_vcf_chr22.vcf.gz
INPUT1=/home/devel/marcmont/scratch/GA/GATK/JOINT/chr22/GA.chr22.144combined.vcf.gz
name=$(echo $INPUT2 | rev |  cut -d/ -f1 | rev)
sample_name="Pan_troglodytes_verus-McVean.variant130"

echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load PYTHON/3.6.3

#MAIN SCRIPT

#create sample_file
python ${SRC}FILTER_extract_variant_highcov.py \
$INPUT1 \
$INPUT2 \
$sample_name \
${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/samples_to_exclude \
chr${chr} \
${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/FILTER_snp_ref_info.gz" > ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/variants_highcov_changed.sh 
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/variants_highcov_changed.sh)
chmod 777 $jobname
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} \
-o ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.out \
-e ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.err \
-n $name -u 1 -t 1 -w 06:00:00
done; done;
