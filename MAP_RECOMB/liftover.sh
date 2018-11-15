#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#SET DIRECTORIES
INDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/cM_maps_BED/"
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/MAP_RECOMB/lifted_chimp_coord/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/MAP_RECOMB/"
BIN="/scratch/devel/avalenzu/Impute_Master_Project/bin/MAP_RECOMB/"

#SET OUTPUT
out=${OUTDIR}"out/"
qu=${OUTDIR}"qu/"
jobname=${qu}"lift_over"

#VARIABLES
chromosomes='1 2a 2b 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22'

#CREATE THIS DIRECTORIES

mkdir -p $OUTDIR
mkdir -p $out
mkdir -p $qu

#MAIN JOB

echo ${chromosomes} | tr " " "\n" | while read chr;
do echo "#!/bin/bash
module load UCSCTOOLS/331
liftOver ${INDIR}chimp_map_BED_chr${chr}.bed ${BIN}panTro2ToHg19.over.chain ${OUTDIR}lifted_chr${chr} ${OUTDIR}unMapped_chr${chr}" > ${jobname}_chr${chr}.sh
chmod 755 ${jobname}_chr${chr}.sh
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname}_chr${chr}.sh -n lift_over -o ${out}_chr${chr}.out -e ${out}_chr${chr}.err -u 1 -t 1 -w 01:00:00
done

