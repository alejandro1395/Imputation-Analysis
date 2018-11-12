#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"

#chimp folders
chimp_names="central-Nico verus-McVean schweinfurthii-A912_Nakuu ellioti-Paquita" 
#We need to have the files from sorted bam with merged name
  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/"
INDIR=${DATA}"DOWNSAMPLING/TAGGED_DOWNS/"
OUTDIR=${DATA}"VCFs_DOWN/"

#MAIN SCRIPT LOOPED FOR 4 CHIMPS

mkdir -p ${OUTDIR}
echo $chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/out/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/tmp/
ls ${INDIR}Pan_troglodytes_${chimp_name}/*_downs.bam | while read filepath; 
do in_file=$(ls $filepath | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
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

java -Djava.io.tmpdir=${OUTDIR}Pan_troglodytes_${chimp_name}/tmp/ -jar /apps/GATK/latest/GenomeAnalysisTK.jar \
-T UnifiedGenotyper \
-R $REF \
-I ${INDIR}Pan_troglodytes_${chimp_name}/$input \
--output_mode EMIT_ALL_SITES | bgzip -c > ${OUTDIR}Pan_troglodytes_${chimp_name}/${name}.g.vcf.gz;
tabix -p vcf ${OUTDIR}Pan_troglodytes_${chimp_name}/${name}.g.vcf.gz" > ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${name}_call.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${name}_call.sh)
chmod 755 $jobname

#/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${name}_call.out \
#-e ${INDIR}Pan_troglodytes_${chimp_name}/out/${name}_call.err -n ${name} -u 8 -t 1 -w 23:50:00
done; done;
