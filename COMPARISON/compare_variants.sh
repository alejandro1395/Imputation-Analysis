#!/usr/bin/bash

module load gcc/4.9.3-gold
module load PYTHON/3.6.3
#VARIABLES
chimp_names="verus-McVean"
chromosomes="22"

#OUTDIR FOR ANALYZING HIGH COVERAGE INDIVIDUAL VCFs

OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/results/Comparison/"

#INPUTS for chr
DATA="/scratch/devel/avalenzu/Impute_Master_Project/results/Impute_out/Pan_troglodytes_verus-McVean/chr22/down_0.106/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/COMPARISON/"

echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}

echo $chromosomes | tr " " "\n" | while read chr;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/out/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/qu/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/tmp/
INPUT=/scratch/devel/avalenzu/Impute_Master_Project/results/Comparison/Pan_troglodytes_verus-McVean/chr22/
echo $INPUT
name=downs_0.106
sample_name="Pan_troglodytes_verus-McVean.variant130"

echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load PYTHON/3.6.3

#MAIN SCRIPT

#create sample_file
python ${SRC}compare_variants.py \
${INPUT}snp_ref_info.gz \
${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/genotypes_0.106 \
${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/comparison_0.106.txt" > ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/compare.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/compare.sh)
chmod 777 $jobname
#/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} \
#-o ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.out \
#-e ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.err \
#-n ${name} -u 1 -t 1 -w 05:00:00
done; done;

