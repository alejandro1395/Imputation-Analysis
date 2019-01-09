#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#SET DIRECTORIES
INDIR="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/MAP_RECOMB/BIG_MAP_HG18/final_maps/"
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/MAP_RECOMB/BIG_MAP_HG18/final_maps_with_cM/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/src/MAP_RECOMB/new_maps_big/"

#SET OUTPUT
out=${OUTDIR}"out/"
qu=${OUTDIR}"qu/"

#VARIABLES
chromosomes='1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22'

#CREATE THIS DIRECTORIES

mkdir -p $OUTDIR
mkdir -p $out
mkdir -p $qu

#MAIN JOB

echo ${chromosomes} | tr " " "\n" | while read chr;
do echo "#!/bin/bash
python ${SRC}final_chimp_to_cM.py ${INDIR}final_chr${chr}.map 1413 ${OUTDIR}final_chr${chr}.map" > ${qu}chr${chr}.sh
chmod 755 ${qu}chr${chr}.sh
#/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${qu}chr${chr}.sh -n from_4Ner_to_cM -o ${out}cM.out -e ${out}cM.err -u 1 -t 1 -w 01:00:00
done
