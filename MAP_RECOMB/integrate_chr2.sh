#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#SET DIRECTORIES
INDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/final_chr_maps/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/MAP_RECOMB/"

#SET OUTPUT
out=${INDIR}"out/"
qu=${INDIR}"qu/"
jobname=${qu}"final_maps"

#MAIN JOB

echo "#!/bin/bash
module load gcc/4.9.3
module load PYTHON/3.6.3
python ${SRC}integrate_chr2.py ${INDIR}final_chr2a.map ${INDIR}final_chr2b.map > ${INDIR}final_chr2.map" > ${jobname}_integr.sh
chmod 755 ${jobname}_integr.sh
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname}_integr.sh -n integr -o ${INDIR}out/integr.out -e ${INDIR}out/integr.err -u 1 -t 1 -w 00:30:00



