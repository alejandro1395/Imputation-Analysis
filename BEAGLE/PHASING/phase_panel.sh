#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"
BIN="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/bin/BEAGLE/"
STUDY_GENS="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/STUDY_GENS/GEN_FILES/"

#chromosomes
#chromosomes=$(echo {5..22})
chromosomes="22"
chimp_name="verus-McVean"
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
mkdir -p ${OUTDIR}/chr${chr}/out/
mkdir -p ${OUTDIR}/chr${chr}/qu/
mkdir -p ${OUTDIR}/chr${chr}/tmp/
INPUT=${DATA}"chr"${chr}"/GA.chr"${chr}".144combined.vcf.gz"
name=$(echo $INPUT | rev |  cut -d/ -f1 | rev)


#MAIN SCRIPT LOOPED FOR CHIMPS CHROMOSOMES
#LOOP CHUNKS IN FIRST CHROMOSOME

num_lines=$(zcat ${STUDY_GENS}Pan_troglodytes_${chimp_name}/chr${chromosomes}/filtered_study_panel_chr22_0.036.gen.gz | wc -l)
last_pos=$(zcat ${STUDY_GENS}Pan_troglodytes_${chimp_name}/chr${chromosomes}/filtered_study_panel_chr22_0.036.gen.gz | sed -n -e ${num_lines},${num_lines}p | cut -d " " -f 3)
num_chunks=$(echo $last_pos/5000000 | bc )
echo $num_chunks
num_chunks2=$(echo $num_chunks+1 | bc)
start=0

#for chunk in $(seq 1 $num_chunks2)
#do endchr=$(echo $start+5000000 | bc)
#startchr=$(echo $start+1 | bc)

echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load GATK/4.0.8.1
module load TABIX/0.2.6
module load VCFTOOLS/0.1.7
module load zlib/1.2.8
module load intel/16.3.067
module load lapack/3.2.1
module load java

#MAIN SCRIPT

java -Xmx70g -Djava.io.tmpdir=${OUTDIR}/chr${chr}/tmp/ \
-XX:-UseGCOverheadLimit \
-jar ${BIN}beagle.28Sep18.793.jar \
gt=${INPUT} \
window=0.1 \
overlap=0.05 \
out=${OUTDIR}chr${chr}/phased_chr${chr}_panel \
map=${OUTDIR}chr${chr}/ref_chr${chr}.map \
excludesamples=${OUTDIR}chr${chr}/samples_to_exclude \
impute=false" > ${OUTDIR}/chr${chr}/qu/ref_panel_chr${chr}.sh
jobname=$(echo ${OUTDIR}/chr${chr}/qu/ref_panel_chr${chr}.sh)
chmod 777 $jobname
#start=$endchr

/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}/chr${chr}/out/ref_panel_chr${chr}.out \
-e ${OUTDIR}/chr${chr}/out/ref_panel_chr${chr}.err -n panel -u 16 -t 1 -w 30:00:00 -r lowprio
done;
# done;
