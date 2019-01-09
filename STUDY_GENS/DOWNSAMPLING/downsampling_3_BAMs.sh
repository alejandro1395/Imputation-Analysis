#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#chimp folders
chimp_names="central-Nico verus-McVean schweinfurthii-A912_Nakuu" 
#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/STUDY_GENS/"
INDIR=${DATA}"BAM_RMDUP/"
OUTDIR=${DATA}"DOWNSAMPLING_1/"


#MAIN SCRIPT LOOPED FOR 3 CHIMPS

mkdir -p ${OUTDIR}
echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/out/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/tmp/
in_file=$(ls ${INDIR}Pan_troglodytes_${chimp_name}/*_rmdup.bam | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)
echo $in_file
echo $input
seq 0.006 0.01 0.11 | while read line;
do number=$(echo $line | sed 's/,/\./')
echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load xz/5.2.2
module load SAMTOOLS/1.3
module load java
module load PICARD/2.8.2

#MAIN SCRIPT
java -Djava.io.tmpdir=${OUTDIR}Pan_troglodytes_${chimp_name}/tmp/ -jar /apps/PICARD/2.8.2/picard.jar DownsampleSam \
I=${INDIR}Pan_troglodytes_${chimp_name}/$input \
O=${OUTDIR}Pan_troglodytes_${chimp_name}/${chimp_name}_${number}_downs.bam \
P=$number \
TMP_DIR=${OUTDIR}Pan_troglodytes_${chimp_name}/tmp/working_tmp" > ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_${number}_downs.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_${number}_downs.sh)
chmod 755 $jobname

/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.downs.out -e ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.downs.err -n ${chimp_name}_${number} -u 4 -t 1 -w 23:30:00
done; done;

