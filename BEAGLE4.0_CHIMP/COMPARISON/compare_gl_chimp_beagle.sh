#!/bin/bash

module load purge
module load PYTHON/3.6.3

IMPUTED_FILES=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_chimp/IMPUTATION/
LOW_COV_FILE=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_chimp/SAMPLES_vcf/
BIN=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/bin/
REF=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/results/HUMAN_TEST/1000Gfiles/data/
OUTDIR=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_chimp/COMPARISON/
SRC=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/src/BEAGLE4.0_CHIMP/COMPARISON/

mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR}qu
mkdir -p ${OUTDIR}out

chimp_samples="Boe1-30 Boe1-32 Boe1-33 Boe1-36 Boe1-43 Boe1-44 Boe1-57 Boe1-60 Boe1-71 Boe1-75 Boe1-77"
echo $chimp_samples | tr " " "\n" | while read sample;
do echo "#!/bin/bash
module load purge
module unload PYTHON
module load PYTHON/3.6.3

python ${SRC}compare_gl_chimp_beagle.py ${IMPUTED_FILES}VCF_all_Boe1_merged_nonmiss.vcf.gz \
${LOW_COV_FILE}VCF_Boe1_merged_nonmiss.vcf.recode.vcf.gz \
$sample \
${OUTDIR}${sample}_comparison.csv" > ${OUTDIR}qu/${sample}_comparison.sh
jobname=$(echo ${OUTDIR}qu/${sample}_comparison.sh)
chmod 755 $jobname

#SUBMISSION TO CLUSTER
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}out/${sample}_comparison.out \
-e ${OUTDIR}out/${sample}_comparison.err -n ${sample} -u 4 -t 1 -w 01:00:00
done;
