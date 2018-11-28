#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3


#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"


#INPUT FASTQ DATA
three_CHIMP_folders="/home/devel/marcmont/scratch/GA/GAGP1-2/"
CENTRAL_CHIMP="/scratch/devel/tmarques/Genomes/Disease_chimps/1512KHX-0016_hdd1/NICO/"
three_chimp_names="verus-McVean schweinfurthii-A912_Nakuu ellioti-Paquita" 

  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/data/STUDY_GENS/"
OUTDIR=${DATA}"BAM/"


#MAIN SCRIPT LOOPED FOR 3 CHIMPS

echo $three_chimp_names | tr " " "\n" | while read chimp_name;
do mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/
mkdir -p ${OUTDIR}Pan_troglodytes_${chimp_name}/out/
echo ${chimp_name}
ls ${three_CHIMP_folders}Pan_troglodytes_${chimp_name}/*_1.fastq.gz | while read path1;
do fastq1=$(echo $path1 | rev | cut -d/ -f1 | rev)
name_fastq=$(echo $fastq1 | sed s/_1.fastq.gz//g)
fastq2=$(echo $fastq1 | sed s/_1.fastq.gz/_2.fastq.gz/g)

#BWA SCRIPT
echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load xz/5.2.2
module load SAMTOOLS/1.3
module load BWA/0.7.7
bwa mem -M -t 8 \
${REF} \
${three_CHIMP_folders}Pan_troglodytes_${chimp_name}/${fastq1} \
${three_CHIMP_folders}Pan_troglodytes_${chimp_name}/${fastq2} | samtools sort -@ 16 -O bam \
-T ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${name_fastq} --reference ${REF} \
-o ${OUTDIR}Pan_troglodytes_${chimp_name}/${name_fastq}.sorted.bam - ;samtools index \
${OUTDIR}Pan_troglodytes_${chimp_name}/${name_fastq}.sorted.bam" > ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${name_fastq}.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${name_fastq}.sh)
chmod 755 $jobname

#SUBMISSION TO CLUSTER
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${name_fastq}.out \
-e ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${name_fastq}.err -n ${name_fastq} -u 8 -t 1 -w 1-23:00:00 -r lowprio
done; done



#MAIN SCRIPT FOR CENTRAL CHIMP

#variable_name
name_4chimp="central-Nico"

mkdir -p ${OUTDIR}Pan_troglodytes_${name_4chimp}
mkdir -p ${OUTDIR}Pan_troglodytes_${name_4chimp}/qu/ 
mkdir -p ${OUTDIR}Pan_troglodytes_${name_4chimp}/out/

#MAPPING LOOP
ls ${CENTRAL_CHIMP}*R1.fastq.gz | while read path1;
do fastq1=$(echo $path1 | rev | cut -d/ -f1 | rev)
name_fastq=$(echo $fastq1 | sed s/R1.fastq.gz//g)
fastq2=$(echo $fastq1 | sed s/R1.fastq.gz/R2.fastq.gz/g)

#BWA SCRIPT
echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load xz/5.2.2
module load SAMTOOLS/1.3
module load BWA/0.7.7
bwa mem -M -t 8 ${REF} ${CENTRAL_CHIMP}${fastq1} ${CENTRAL_CHIMP}${fastq2} | samtools sort -@ 16 -O bam -T ${OUTDIR}Pan_troglodytes_${name_4chimp}/out/${name_fastq} --reference ${REF} \
-o ${OUTDIR}Pan_troglodytes_${name_4chimp}/${name_fastq}.sorted.bam - ;samtools index \
${OUTDIR}Pan_troglodytes_${name_4chimp}/${name_fastq}.sorted.bam" > ${OUTDIR}Pan_troglodytes_${name_4chimp}/qu/${name_fastq}.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${name_4chimp}/qu/${name_fastq}.sh)
chmod 755 $jobname

#SUBMISSION TO CLUSTER
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${name_4chimp}/out/${name_fastq}.out \
-e ${OUTDIR}Pan_troglodytes_${name_4chimp}/out/${name_fastq}.err -n ${name_fastq} -u 8 -t 1 -w 1-23:00:00 -r lowprio                                   
done; 
