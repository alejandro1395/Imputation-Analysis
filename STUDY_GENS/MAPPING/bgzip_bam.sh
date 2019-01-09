#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3


#chimp folders
chimp_names="central-Nico verus-McVean schweinfurthii-A912_Nakuu ellioti-Paquita" 

  
#BAM INPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/STUDY_GENS/"
INDIR=${DATA}"BAM/"

#FIRST WE NEED TO CHANGE THE NAME FOR Verus and Central to merged bam file


#MAIN SCRIPT LOOPED FOR 3 CHIMPS

echo $chimp_names | tr " " "\n" | while read chimp_name;
do echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load xz/5.2.2
module load SAMTOOLS/1.3
cd ${INDIR}Pan_troglodytes_${chimp_name}; bgzip *.merged.bam" > ${INDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_bgzip.sh
jobname=$(echo ${INDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_bgzip.sh)
chmod 755 $jobname
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${INDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.bgzip.out \
-e ${INDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.bgzip.err -n ${chimp_name} -u 1 -t 1 -w 03:00:00
done
