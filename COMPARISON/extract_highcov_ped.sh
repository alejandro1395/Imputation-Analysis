#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

chimp_names="verus-McVean"
chromosomes="22"

#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"
BIN="/scratch/devel/avalenzu/Impute_Master_Project/bin/PANEL_REF/"

#OUTDIR FOR ANALYZING HIGH COVERAGE INDIVIDUAL VCFs

OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/results/Comparison/"

#INPUTS for chr
DATA="/home/devel/marcmont/scratch/GA/GATK/JOINT/"

echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}

echo $chromosomes | tr " " "\n" | while read chr;
do mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/out/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/qu/
mkdir -p ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/tmp/
INPUT=${DATA}"chr"${chr}"/GA.chr"${chr}".144combined.vcf.gz"
echo $INPUT
name=$(echo $INPUT | rev |  cut -d/ -f1 | rev)
echo "Pan_troglodytes_verus-McVean.variant130	Pan_troglodytes_verus-McVean.variant130" > ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/sample_name

echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load GATK/4.0.8.1
module load TABIX/0.2.6
module load VCFTOOLS/0.1.7
module load zlib/1.2.8
module load intel/16.3.067
module load lapack/3.2.1
module load PLINK/1.90b

#MAIN SCRIPT

${BIN}plink --vcf ${INPUT} \
--double-id \
--keep ${OUTDIR}/Pan_troglodytes_${chimp_name}/chr${chr}/sample_name \
--recode 01 \
--out ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/ref_info_chr${chr}_ped" > ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/ref_info_ped.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/ref_info_ped.sh)
chmod 755 $jobname

#/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} \
-o ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/ref_info_ped.out \
-e ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/qu/ref_info_ped.err -n ${name} -u 4 -t 1 -w 05:00:00
done; done;
