#!/usr/bin/bash

module load gcc/4.9.3-gold
module load PYTHON/3.6.3
#VARIABLES
chimp_names="verus-McVean"
chromosomes="22"

#OUTDIR FOR ANALYZING HIGH COVERAGE INDIVIDUAL VCFs

OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/results/Comparison/"

#INPUTS for chr
DATA="/home/devel/marcmont/scratch/GA/GATK/JOINT/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/COMPARISON/"

echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}

echo $chromosomes | tr " " "\n" | while read chr;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/out/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/qu/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/tmp/
INPUT=/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/VCFs_DOWN/Pan_troglodytes_verus-McVean/verus-McVean_0.056_downs.g.vcf.gz
echo $INPUT
name=$(echo $INPUT | rev |  cut -d/ -f1 | rev)
sample_name="verus-McVean_0.056_downs"

echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load PYTHON/3.6.3

#MAIN SCRIPT

#create sample_file
python ${SRC}extract_variant_genotypes.py \
$INPUT \
$sample_name \
chr${chr} \
${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/snp_down_0.056_info" > ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/variants_lowcov.sh 
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/variants_lowcov.sh)
chmod 777 $jobname
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} \
-o ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.out \
-e ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.err \
-n $name -u 1 -t 1 -w 06:00:00
done; done;