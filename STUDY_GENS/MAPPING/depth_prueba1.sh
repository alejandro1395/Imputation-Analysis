#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#chimp folders
chimp_names="central-Nico" 
#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/"
INDIR=${DATA}"DOWNSAMPLING/"
OUTDIR=${INDIR}"PRUEBA_1/"

#MAIN SCRIPT LOOPED FOR 3 CHIMPS

mkdir -p ${OUTDIR}
echo $chimp_names | tr " " "\n" | while read chimp_name;
do ls ${INDIR}Pan_troglodytes_${chimp_name}/*_downs.bam | while read filepath;
do in_file=$(ls $filepath | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)
echo $input
echo "#!/bin/bash

#MAIN SCRIPT
samtools depth -a ${INDIR}Pan_troglodytes_${chimp_name}/$input | python histogram_cov.py | sort -n | uniq > ${OUTDIR}${input}.txt" > ${OUTDIR}${input}.sh
jobname=$(echo ${OUTDIR}${input}.sh)
chmod 755 $jobname
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}${input}.out -e ${OUTDIR}${input}.err -n ${chimp_name} -u 1 -t 1 -w 23:30:00
done; done;



