#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"
BIN="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/bin/PANEL_REF/"

#chromosomes
#chromosomes=$(echo {5..22})
chromosomes="22"
#We need to have the files from sorted bam with merged name

#OUTPUT
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/BEAGLE/PANEL/"
mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR}qu/
mkdir -p ${OUTDIR}out/
mkdir -p ${OUTDIR}tmp/


#INPUTS for chr
DATA="/home/devel/marcmont/scratch/GA/GATK/JOINT/"
echo $chromosomes | tr " " "\n" | while read chr;
do mkdir -p ${OUTDIR}/chr${chr}
mkdir -p ${OUTDIR}/chr${chr}/qu/
mkdir -p ${OUTDIR}/chr${chr}/out/
mkdir -p ${OUTDIR}/chr${chr}/tmp/		 
INPUT=${DATA}"chr"${chr}"/GA.chr"${chr}".144combined.vcf.gz"
name=$(echo $INPUT | rev |  cut -d/ -f1 | rev)


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
module load PLINK/1.90b

#MAIN SCRIPT

${BIN}plink --vcf ${INPUT} \
--keep /scratch/devel/avalenzu/Impute_Master_Project/data/PANEL_REF/samples_file \
--double-id --recode \
--out ${OUTDIR}chr${chr}/ref_panel_chr${chr}" > ${OUTDIR}/chr${chr}/qu/ref_panel_chr${chr}.sh
jobname=$(echo ${OUTDIR}/chr${chr}/qu/ref_panel_chr${chr}.sh)
chmod 777 $jobname

/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}/chr${chr}/out/ref_panel_chr${chr}.out -e ${OUTDIR}/chr${chr}/out/ref_panel_chr${chr}.err -n ${name} -u 4 -t 1 -w 05:00:00
done;
