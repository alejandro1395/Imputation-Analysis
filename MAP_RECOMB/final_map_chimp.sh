#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#SET DIRECTORIES
INDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/lifted_chimp_coord/"
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/final_chr_maps/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/MAP_RECOMB/"
BIN="/scratch/devel/avalenzu/Impute_Master_Project/bin/MAP_RECOMB/"
DATA="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/"

#SET OUTPUT
out=${OUTDIR}"out/"
qu=${OUTDIR}"qu/"
jobname=${qu}"final_maps"

#VARIABLES
chromosomes_eq='1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22'
chromosomes_dif='2a 2b'
#CREATE THIS DIRECTORIES

mkdir -p $OUTDIR
mkdir -p $out
mkdir -p $qu

#MAIN JOB

echo ${chromosomes_eq} | tr " " "\n" | while read chr;
do echo "#!/bin/bash
module load gcc/4.9.3
module load PYTHON/3.6.3
python introduce_correct_coord_map.py ${INDIR}unMapped_chr${chr} ${INDIR}lifted_chr${chr} ${DATA}cM_maps_chimpcoord/chimp_map_chr${chr}.map \
chr${chr} > ${OUTDIR}final_chr${chr}.map" > ${jobname}_chr${chr}.sh
chmod 755 ${jobname}_chr${chr}.sh
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname}_chr${chr}.sh -n chroms -o ${OUTDIR}out/chr${chr}.out -e ${OUTDIR}out/chr${chr}.err -u 1 -t 1 -w 00:30:00
done

echo ${chromosomes_dif} | tr " " "\n" | while read chr;
do num=${chr:0:1}
echo "#!/bin/bash
module load gcc/4.9.3
module load PYTHON/3.6.3
python introduce_correct_coord_map.py ${INDIR}unMapped_chr${chr} ${INDIR}lifted_chr${chr} ${DATA}cM_maps_chimpcoord/chimp_map_chr${chr}.map \
chr${num} > ${OUTDIR}final_chr${chr}.map" > ${jobname}_chr${chr}.sh
chmod 755 ${jobname}_chr${chr}.sh
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname}_chr${chr}.sh -n chroms -o ${OUTDIR}out/chr${chr}.out -e ${OUTDIR}out/chr${chr}.err -u 1 -t 1 -w 00:30:00
done


