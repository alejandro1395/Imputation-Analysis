#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#REFERENCE
REF=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/results/HUMAN_TEST/1000Gfiles/data/human_g1k_v37.fasta

#BAM OUTPUT
DATA=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/results/HUMAN_TEST/1000Gfiles/data/
OUTDIR=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_human/SAMPLES_vcf/
PANEL=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_jan2019_panel300/BEAGLE_4.0_analysis_human/REF/filtered_1000G_panel.vcf.gz

#MAIN SCRIPT LOOPED FOR HUMAN BAMs

mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR}qu/
mkdir -p ${OUTDIR}out/
mkdir -p ${OUTDIR}tmp/

BAM_input=""
for filepath in $(ls ${DATA}HG0*.bam);
do in_file=$(ls $filepath | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
BAM_input+="-I ${filepath} "
done
BAMs=$(echo $BAM_input)


#cat ${OUTDIR}VCFs_ref/SamplesWestern | while read line;
#do echo ${line}
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

java -Djava.io.tmpdir=${OUTDIR}tmp/ -jar /apps/GATK/latest/GenomeAnalysisTK.jar \
-T UnifiedGenotyper \
-R $REF \
$BAMs \
-L 20 \
--output_mode EMIT_ALL_SITES --genotype_likelihoods_model SNP \
--allSitePLs --genotyping_mode GENOTYPE_GIVEN_ALLELES \
--alleles ${PANEL} | bgzip -c > ${OUTDIR}Hum_chr20_merged.g.vcf.gz;
tabix -p vcf ${OUTDIR}Hum_chr20_merged.g.vcf.gz" > ${OUTDIR}qu/Hum_chr20_merged_call.sh
jobname=$(echo ${OUTDIR}qu/Hum_chr20_merged_call.sh)
chmod 755 $jobname

#SUBMISSION TO CLUSTER
#/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}VCFs_ref/out/${line}_call.out \
#-e ${OUTDIR}VCFs_ref/out/${line}_call.err -n ${line} -u 4 -t 1 -w 15:00:00
#done;
