#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"
BIN="/scratch/devel/avalenzu/Impute_Master_Project/bin/PANEL_REF/"
SRC="/scratch/devel/avalenzu/Impute_Master_Project/src/BEAGLE/IMPUTING/"
PANEL="/home/devel/marcmont/scratch/GA/GATK/JOINT/"

#OUTPUT
INDIR="/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/VCFs_DOWN/"
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/results/BEAGLE/IMPUTE_OUT/"
mkdir -p ${OUTDIR}

#INPUTS for chr and chimps
chimp_names="verus-McVean"
chromosomes="22"
coverages="0.006 0.036 0.056 0.076 0.106"
echo $chimp_names | tr " " "\n" | while read chimp_name;
do echo $chromosomes | tr " " "\n" | while read chr;
do mkdir -p ${OUTDIR}chr${chr}                             
mkdir -p ${OUTDIR}chr${chr}/qu/
mkdir -p ${OUTDIR}chr${chr}/out/
mkdir -p ${OUTDIR}chr${chr}/tmp/
echo $coverages | tr " " "\n" | while read cov;
do filepath=$(ls ${INDIR}/Pan_troglodytes_${chimp_name}/*${cov}_downs.g.vcf.gz) 
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
${INDIR}Pan_troglodytes_${chimp_name}/$input \
${PANEL}chr${chr}/GA.chr${chr}.144combined.vcf.gz \
${OUTDIR}chr${chr}/filtered_${input}" > ${OUTDIR}chr${chr}/qu/filtered_study_panel_chr${chr}_${cov}.sh
jobname=$(echo ${OUTDIR}chr${chr}/qu/filtered_study_panel_chr${chr}_${cov}.sh)
chmod 755 $jobname

#SUBMISSION TO CLUSTER
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}chr${chr}/out/filtered_ref_panel_chr${chr}_${cov}.out \
-e ${OUTDIR}chr${chr}/out/filtered_ref_panel_chr${chr}_${cov}.err -n ${cov} -u 4 -t 1 -w 05:00:00
done; done; done;
