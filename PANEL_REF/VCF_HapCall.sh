#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"

#chimp folders
chimp_names="verus-McVean" 
#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/data/"
INDIR="/scratch/devel/cfontser/PanAf/CHR21/Final_Bam_August/BAM_addRG/"
OUTDIR=${DATA}PANEL_REF/

#MAIN SCRIPT LOOPED FOR 4 CHIMPS

mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR}VCFs_ref/
mkdir -p ${OUTDIR}VCFs_ref/qu/
mkdir -p ${OUTDIR}VCFs_ref/out/
mkdir -p ${OUTDIR}VCFs_ref/tmp/
ls ${INDIR}*.addRG.bam | tr " " "\n" |  while read bam_file; 
do in_file=$(ls $bam_file | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
input=$(echo $in_file)
echo $input
name=$(echo $input | rev | cut -c5- | rev )
echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load xz/5.2.2
module load SAMTOOLS/1.3
module load java
module load GATK/4.0.8.1
module load TABIX/0.2.6
module load VCFTOOLS/0.1.7

#MAIN SCRIPT

java -Djava.io.tmpdir=${OUTDIR}VCFs_ref/tmp/ -jar /apps/GATK/latest/GenomeAnalysisTK.jar \
-T UnifiedGenotyper \
-R $REF \
-I ${INDIR}$input \
-L chr21 \
--output_mode EMIT_ALL_SITES | bgzip -c > ${OUTDIR}VCFs_ref/${name}.g.vcf.gz;
tabix -p vcf ${OUTDIR}VCFs_ref/${name}.g.vcf.gz" > ${OUTDIR}VCFs_ref/qu/${name}_call.sh
jobname=$(echo ${OUTDIR}VCFs_ref/qu/${name}_call.sh)
chmod 755 $jobname

#SUBMISSION TO CLUSTER
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}VCFs_ref/out/${name}_call.out \
-e ${OUTDIR}VCFs_ref/out/${name}_call.err -n ${name} -u 4 -t 1 -w 52:00:00 -r lowprio
done;
