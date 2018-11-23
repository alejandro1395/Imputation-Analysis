#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#chimp folders
chimp_names="central-Nico" 
#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/"
INDIR=${DATA}"BAM_RMDUP/"
OUTDIR=${DATA}"DOWNSAMPLING/TAGGED_DOWNS/"

#MAIN SCRIPT LOOPED FOR 3 CHIMPS

mkdir -p ${OUTDIR}
echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/out/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/
ls ${INDIR}Pan_troglodytes_${chimp_name}/*rmdup.bam | while read filepath;
do in_file=$(ls $filepath | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)
name=$(echo $input | rev | cut -c5- | rev )
echo $input
echo "#!/bin/bash

#MAIN SCRIPT
/scratch/devel/avalenzu/Impute_Master_Project/bin/STUDY_GENES/bamaddrg/bamaddrg -b ${INDIR}Pan_troglodytes_${chimp_name}/$input \
-s $name -r $name > ${OUTDIR}Pan_troglodytes_${chimp_name}/${name}.bam; samtools index ${OUTDIR}Pan_troglodytes_${chimp_name}/${name}.bam" > ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${name}.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${name}.sh)
chmod 755 $jobname
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${name}.out -e ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${name}.err -n ${name} -u 4 -t 1 -w 15:00:00
done; done;
