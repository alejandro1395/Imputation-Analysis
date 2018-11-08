#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#chimp folders
chimp_names="central-Nico verus-McVean schweinfurthii-A912_Nakuu ellioti-Paquita" 
#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/"
INDIR=${DATA}"BAM_RMDUP/"
OUTDIR=${INDIR}"COV_HIST/"

#MAIN SCRIPT LOOPED FOR 3 CHIMPS

mkdir -p ${OUTDIR}
echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/out/
in_file=$(ls ${INDIR}Pan_troglodytes_${chimp_name}/*_rmdup.bam | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)
echo $input
echo "#!/bin/bash

#MAIN SCRIPT
samtools depth -a ${INDIR}Pan_troglodytes_${chimp_name}/$input | python histogram_cov.py | sort -n | uniq > ${OUTDIR}Pan_troglodytes_${chimp_name}/${chimp_name}_cov.txt" \
> ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_cov.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_cov.sh)
chmod 755 $jobname

/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.cov.out \
-e ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.cov.err -n ${chimp_name} -u 1 -t 1 -w 23:30:00
done



