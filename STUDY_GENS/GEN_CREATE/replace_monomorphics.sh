#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"
BIN="/scratch/devel/avalenzu/Impute_Master_Project/bin/PANEL_REF/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/STUDY_GENS/GEN_CREATE/"
PANEL="/home/devel/marcmont/scratch/GA/GATK/JOINT/"

#OUTPUT
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/GEN_FILES/"
mkdir -p ${OUTDIR}

#INPUTS for chr and chimps
chimp_names="verus-McVean"
chromosomes="22"
coverages="0.006"
echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/out/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/tmp/
echo $chromosomes | tr " " "\n" | while read chr;
do mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}
echo $coverages | tr " " "\n" | while read cov;
do filepath=$(ls ${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/*_${cov}.gen.gz) 
in_file=$(ls $filepath | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)


#MAIN SCRIPT LOOPED FOR CHIMPS CHROMOSOMES


echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load GATK/4.0.8.1
module load TABIX/0.2.6
module load VCFTOOLS/0.1.7
module load zlib/1.2.8
module load intel/16.3.067
module load lapack/3.2.1
module load PYTHON/3.6.3

#MAIN SCRIPT

python ${SRC}replace_monomorphics.py \
${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/$input \
${PANEL}chr${chr}/GA.chr${chr}.144combined.vcf.gz \
${OUTDIR}Pan_troglodytes_${chimp_name}/chr${chr}/filtered_${input}" > ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/filtered_study_panel_chr${chr}.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/filtered_study_panel_chr${chr}.sh)
chmod 755 $jobname

#SUBMISSION TO CLUSTER
#/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${chimp_name}/out/filtered_ref_panel_chr${chr}.out \
#-e ${OUTDIR}Pan_troglodytes_${chimp_name}/out/filtered_ref_panel_chr${chr}.err -n ${cov} -u 4 -t 1 -w 05:00:00
done; done; done;
