#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"
PANEL=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/data/PANEL/

#chimp folders

#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/data/
INDIR=/scratch/devel/cfontser/PanAf/CHR21/Final_Bam_August/BAM_addRG/
OUTDIR=${DATA}SAMPLES_LOW/

#MAIN SCRIPT LOOPED FOR 4 CHIMPS

mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR}VCFs_bcftools_mpileup/
mkdir -p ${OUTDIR}VCFs_bcftools_mpileup/qu/
mkdir -p ${OUTDIR}VCFs_bcftools_mpileup/out/
mkdir -p ${OUTDIR}VCFs_bcftools_mpileup/tmp/

cat ${OUTDIR}VCFs_ref/SamplesWestern | while read line;
do echo ${line}
echo "#!/bin/bash
module purge
module unload gcc
module load gcc/6.3.0
module load xz/5.2.2
module load java
module load TABIX/0.2.6
module load BCFTOOLS

#MAIN SCRIPT

bcftools mpileup -r chr21 --skip-indels -Oz --threads 4 -f $REF ${INDIR}${line}*.bam | bcftools call -mv --constrain alleles -T ${PANEL}als.tsv.gz -Oz -o ${OUTDIR}VCFs_bcftools_mpileup/${line}.vcf" > \
${OUTDIR}VCFs_bcftools_mpileup/qu/${line}_call.sh
jobname=$(echo ${OUTDIR}VCFs_bcftools_mpileup/qu/${line}_call.sh)
chmod 755 $jobname


#SUBMISSION TO CLUSTER
#/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}VCFs_ref/out/${line}_call.out \
#-e ${OUTDIR}VCFs_ref/out/${line}_call.err -n ${line} -u 4 -t 1 -w 15:00:00
done;
