#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#SET DIRECTORIES
INDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/MAP_GH18/chimps_map_pre/"
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/MAP_GH18/chimps_map_conv/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/MAP_RECOMB/new_maps/"

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
python ${SRC}hg18_convert_to_cM.py ${INDIR}chimp_chr${chr}.map 11413 ${OUTDIR}chimp_chr${chr}.map" > ${qu}chr${chr}.sh
chmod 755 ${qu}chr${chr}.sh
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${qu}chr${chr}.sh -n from_4Ner_to_cM -o ${out}cM.out -e ${out}cM.err -u 1 -t 1 -w 01:00:00
done
