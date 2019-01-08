#!/usr/bin/bash

module load gcc/4.9.3-gold
module load PYTHON/3.6.3
#VARIABLES
chimp_names="verus-McVean"
chromosomes="22"
coverages="0.006 0.036 0.056 0.076 0.106 0.35"

#OUTDIR FOR ANALYZING HIGH COVERAGE INDIVIDUAL VCFs

OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/results/Comparison/"

#INPUTS for chr
echo $coverages | tr " " "\n" | while read cov; 
do DATA="/scratch/devel/avalenzu/Impute_Master_Project/results/Impute_out/Pan_troglodytes_verus-McVean/chr22/down_${cov}/"
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
name=downs_${cov}
sample_name="Pan_troglodytes_verus-McVean.variant130"

echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load PYTHON/3.6.3

#MAIN SCRIPT

#create sample_file
python ${SRC}compare_beagle.py \
${INPUT}snp_ref_info.gz \
${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/genotypes/filtered_genotype_${cov} \
${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/comparison_files/filtered_comparison_${cov}.txt" > ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/filtered_compare_${cov}.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/filtered_compare_${cov}.sh)
chmod 777 $jobname
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} \
-o ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.out \
-e ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.err \
-n ${name} -u 4 -t 1 -w 05:00:00
done; done; done;
