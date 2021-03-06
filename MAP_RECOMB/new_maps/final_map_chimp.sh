#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#SET DIRECTORIES
INDIR1="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/MAP_GH18/lifted_coord/"
INDIR2="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/MAP_GH18/chimps_map_conv/"
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/MAP_GH18/final_chr_maps/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/MAP_RECOMB/new_maps/"
BIN="/scratch/devel/avalenzu/Impute_Master_Project/bin/MAP_RECOMB/"
DATA="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/"

#SET OUTPUT
out=${OUTDIR}"out/"
qu=${OUTDIR}"qu/"

#VARIABLES
chromosomes_eq='1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22'
#CREATE THIS DIRECTORIES

mkdir -p $OUTDIR
mkdir -p $out
mkdir -p $qu

#MAIN JOB

echo ${chromosomes_eq} | tr " " "\n" | while read chr;
do echo "#!/bin/bash
module load gcc/4.9.3
module load PYTHON/3.6.3
python ${SRC}join_lifted_map.py ${INDIR1}unMapped_chr${chr} ${INDIR1}lifted_chr${chr} ${INDIR2}chimp_chr${chr}.map \
chr${chr} > ${OUTDIR}final_chr${chr}.map" > ${qu}chr${chr}.sh
chmod 755 ${qu}chr${chr}.sh
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${qu}chr${chr}.sh -n chroms -o ${OUTDIR}out/chr${chr}.out -e ${OUTDIR}out/chr${chr}.err -u 1 -t 1 -w 00:30:00
done


