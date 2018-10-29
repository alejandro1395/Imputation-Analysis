#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#SET DIRECTORIES
IN="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/"
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/cM_maps_chimpcoord/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/MAP_RECOMB/"

#SET OUTPUT
out=${OUTDIR}"out/"
qu=${OUTDIR}"qu/"
jobname=${qu}"convert_to_cM.sh"

#VARIABLES
chromosomes='1 2a 2b 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22'

#CREATE THIS DIRECTORIES

mkdir -p $OUTDIR
mkdir -p $out
mkdir -p $qu

#MAIN JOB

echo ${chromosomes} | tr " " "\n" | while read chr;
do echo "#!/bin/bash
python ${SRC}convert_4Ner_to_cM.py ${IN}chimp_Dec8_Haplotypes_Mar1_chr${chr}-cleaned.txt.gz 11413 ${OUTDIR}chimp_map_chr${chr}.map" >> ${jobname}
chmod 755 ${jobname}
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -n from_4Ner_to_cM -o ${out}cM.out -e ${out}cM.err -u 1 -t 1 -w "01:00:00"
done

