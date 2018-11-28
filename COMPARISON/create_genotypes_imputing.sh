#!/usr/bin/bash

module load gcc/4.9.3-gold
module load PYTHON/3.6.3
#VARIABLES
chimp_names="verus-McVean"
chromosomes="22"

#OUTDIR FOR ANALYZING HIGH COVERAGE INDIVIDUAL VCFs

OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/results/Comparison/"

#INPUTS for chr
DATA="/scratch/devel/avalenzu/Impute_Master_Project/results/Impute_out/Pan_troglodytes_verus-McVean/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/COMPARISON/"

echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}

echo $chromosomes | tr " " "\n" | while read chr;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/out/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/qu/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/tmp/
INPUT=${DATA}chr${chromosomes}/down_0.036
echo $INPUT
name=$(echo $INPUT | rev |  cut -d/ -f1 | rev)
sample_name="Pan_troglodytes_verus-McVean.variant130"

echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load PYTHON/3.6.3

#MAIN SCRIPT

#create sample_file
python ${SRC}create_imputed_genotypes.py \
${INPUT}/chr${chromosomes}.all.unphased.impute2.gz \
${INPUT}/chr${chromosomes}.all.unphased.impute2_info \
${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/genotypes_0.036 \
0.3" > ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/genotype.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/genotype.sh)
chmod 777 $jobname
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} \
-o ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.out \
-e ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/out/${name}.err \
-n $name -u 1 -t 1 -w 02:00:00
done; done;
