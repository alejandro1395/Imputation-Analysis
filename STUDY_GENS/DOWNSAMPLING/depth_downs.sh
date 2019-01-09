#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#chimp folders
chimp_names="ellioti-Paquita verus-McVean schweinfurthii-A912_Nakuu" 
#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/STUDY_GENS/"
INDIR=${DATA}"DOWNSAMPLING/TAGGED_DOWNS/"
OUTDIR=${DATA}"DOWNSAMPLING/DEPTHS/"

#MAIN SCRIPT LOOPED FOR 3 CHIMPS

mkdir -p ${OUTDIR}
echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir ${OUTDIR}Pan_troglodytes_${chimp_name}
mkdir ${OUTDIR}Pan_troglodytes_${chimp_name}/out/
mkdir ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/
ls ${INDIR}Pan_troglodytes_${chimp_name}/*0.35_downs.bam | while read filepath;
do in_file=$(ls $filepath | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)
echo $input
echo "#!/bin/bash

#MAIN SCRIPT
samtools depth -a ${INDIR}Pan_troglodytes_${chimp_name}/$input | python histogram_cov.py | sort -n | uniq > \
${OUTDIR}Pan_troglodytes_${chimp_name}/${input}.txt" > ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${input}.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${input}.sh)
chmod 755 $jobname
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${input}.out -e ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${input}.err -n ${input} -u 1 -t 1 -w 15:00:00
done; done;
