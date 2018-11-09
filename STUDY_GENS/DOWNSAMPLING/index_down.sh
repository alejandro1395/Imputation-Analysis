#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#chimp folders
chimp_names="central-Nico verus-McVean schweinfurthii-A912_Nakuu ellioti-Paquita" 
#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/"
INDIR=${DATA}"DOWNSAMPLING/"


#MAIN SCRIPT LOOPED FOR 3 CHIMPS

echo $chimp_names | tr " " "\n" | while read chimp_name;
do ls ${INDIR}Pan_troglodytes_${chimp_name}/*_downs.bam | while read filepath; 
do in_file=$(ls $filepath | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)
echo $input
echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load xz/5.2.2
module load SAMTOOLS/1.3
module load java
module load PICARD/2.8.2

#MAIN SCRIPT
samtools index ${INDIR}Pan_troglodytes_${chimp_name}/$input" > ${INDIR}Pan_troglodytes_${chimp_name}/qu/${input}_index.sh
jobname=$(echo ${INDIR}Pan_troglodytes_${chimp_name}/qu/${input}_index.sh)
chmod 755 $jobname

/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${INDIR}Pan_troglodytes_${chimp_name}/out/${input}_index.out -e ${INDIR}Pan_troglodytes_${chimp_name}/out/${input}_index.err -n ${input}_index.sh -u 4 -t 1 -w 06:00:00
done; done;

