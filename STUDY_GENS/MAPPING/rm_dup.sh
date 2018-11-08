#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#chimp folders
chimp_names="central-Nico verus-McVean schweinfurthii-A912_Nakuu ellioti-Paquita" 
#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/"
INDIR=${DATA}"BAM/"
OUTDIR=${DATA}"BAM_RMDUP/"


#MAIN SCRIPT LOOPED FOR 3 CHIMPS

mkdir -p ${OUTDIR}
echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/out/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/tmp/
in_file=$(ls ${INDIR}Pan_troglodytes_${chimp_name}/*.merged.bam | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)
echo $in_file
echo $input
echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load xz/5.2.2
module load SAMTOOLS/1.3
module load java
module load PICARD/2.8.2

#MAIN SCRIPT
java -Djava.io.tmpdir=${OUTDIR}Pan_troglodytes_${chimp_name}/tmp/ -jar /apps/PICARD/2.8.2/picard.jar MarkDuplicates I=${INDIR}Pan_troglodytes_${chimp_name}/$input O=${OUTDIR}Pan_troglodytes_${chimp_name}/${chimp_name}_rmdup.bam M=${OUTDIR}Pan_troglodytes_${chimp_name}/${chimp_name}_metrics.txt REMOVE_DUPLICATES=true TMP_DIR=${OUTDIR}Pan_troglodytes_${chimp_name}/tmp/working_tmp;
samtools index ${OUTDIR}Pan_troglodytes_${chimp_name}/${chimp_name}_rmdup.bam " > ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_rmdup.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_rmdup.sh)
chmod 755 $jobname

/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.rmdup.out \
-e ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.rmdup.err -n ${chimp_name} -u 8 -t 1 -w 23:30:00
done



