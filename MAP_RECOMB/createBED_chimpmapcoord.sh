#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#SET DIRECTORIES
IN="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/cM_maps_chimpcoord/"
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/cM_maps_BED/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/MAP_RECOMB/"

#SET OUTPUT
out=${OUTDIR}"out/"
qu=${OUTDIR}"qu/"
jobname=${qu}"createBED_chimpmapcoord.sh"

#VARIABLES
chromosomes='1 2a 2b 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22'

#CREATE THIS DIRECTORIES

mkdir -p $OUTDIR
mkdir -p $out
mkdir -p $qu

#MAIN JOB

echo ${chromosomes} | tr " " "\n" | while read chr;
do echo "#!/bin/bash
python ${SRC}createBED_chimpmapcoord.py ${IN}chimp_map_chr${chr}.map ${OUTDIR}chimp_map_BED_chr${chr}.bed" >> ${jobname}
chmod 755 ${jobname}
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -n createBED_chimpmapcoord -o ${out}BED.out -e ${out}BED.err -u 1 -t 1 -w "01:00:00"
done

