#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3
  
#BAM OUTPUT
DATA=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/results/HUMAN_TEST/1000Gfiles/data/
OUTDIR=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_human/BAMs/

#MAIN SCRIPT LOOPED FOR 3 CHIMPS

mkdir -p ${OUTDIR}qu/
mkdir -p ${OUTDIR}out/

ls ${DATA}HG0*.bam | while read filepath; 
do in_file=$(ls $filepath | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)
echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load PYTHON/3.6.3
module load xz/5.2.2
module load SAMTOOLS/1.3
module load java
module load GATK/4.0.8.1
module load TABIX/0.2.6
module load VCFTOOLS/0.1.7

#MAIN SCRIPT

samtools depth -a ${DATA}${input} | python histogram_cov.py | sort -n | uniq > ${OUTDIR}${input}_depth" > ${OUTDIR}qu/${input}_depth.sh; 
jobname=$(echo ${OUTDIR}qu/${input}_depth.sh)
chmod 755 $jobname

/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}out/${input}_depth.out \
-e ${OUTDIR}out/${input}_depth.err -n ${input} -u 4 -t 1 -w 10:00:00
done;
