#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3
  
#BAM OUTPUT
DATA=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.1_analysis_chimp/SAMPLES_LOW/
OUTDIR=${DATA}depths_western/

#MAIN SCRIPT LOOPED FOR 3 CHIMPS

cat ${DATA}VCFs_ref/samples_western_chimp | while read line; 
do mkdir -p ${OUTDIR}qu/
mkdir -p ${OUTDIR}out/

echo "#!/bin/bash

#MAIN SCRIPT

samtools depth -a /scratch/devel/cfontser/PanAf/CHR21/Final_Bam_August/BAM/$line \
| python histogram_cov.py | sort -n | uniq > ${OUTDIR}${line}_depth" > ${OUTDIR}qu/${line}_depth.sh; 
jobname=$(echo ${OUTDIR}qu/${line}_depth.sh)
chmod 755 $jobname

/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}out/${line}_depth.out \
-e ${OUTDIR}out/${line}_depth.err -n ${line} -u 4 -t 1 -w 10:00:00
done;
