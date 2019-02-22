#!/bin/bash

module load purge
module load PYTHON/3.6.3

IMPUTED_FILES=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_human/IMPUTATION/
LOW_COV_FILE=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_human/SAMPLES_vcf/
BIN=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/bin/
REF=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/results/HUMAN_TEST/1000Gfiles/data/
OUTDIR=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_human/COMPARISON/
SRC=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/src/BEAGLE4.0_HUM/COMPARISON/

mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR}qu
mkdir -p ${OUTDIR}out

human_samples="HG03977 HG03978 HG03985 HG03986 HG03989 HG03990 HG03991 HG03995 HG03998 HG03999"
echo $human_samples | tr " " "\n" | while read sample;
do echo "#!/bin/bash
module load purge
module unload PYTHON
module load PYTHON/3.6.3

python ${SRC}R2dist.py ${IMPUTED_FILES}VCF_all_Boe1_merged_nonmiss.vcf.gz \
${LOW_COV_FILE}Hum_chr20_merged.g.vcf.gz \
$sample \
${OUTDIR}${sample}_R2dist.csv" > ${OUTDIR}qu/${sample}_R2dist.sh
jobname=$(echo ${OUTDIR}qu/${sample}_R2dist.sh)
chmod 755 $jobname

#SUBMISSION TO CLUSTER
#/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}out/${sample}_R2dist.out \
#-e ${OUTDIR}out/${sample}_R2dist.err -n ${sample} -u 4 -t 1 -w 01:00:00
done;
