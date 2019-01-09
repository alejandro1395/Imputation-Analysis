#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3


#chimp folders which need merging
chimp_names="schweinfurthii-A912_Nakuu ellioti-Paquita" 

  
#BAM OUTPUT
DATA="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/STUDY_GENS/"
OUTDIR=${DATA}"BAM/"



#MAIN SCRIPT LOOPED FOR 3 CHIMPS

echo $chimp_names | tr " " "\n" | while read chimp_name;
do bams=$(ls ${OUTDIR}Pan_troglodytes_${chimp_name}/*.sorted.bam | tr " " "\n" | rev | cut -d/ -f1 | rev | tr "\n" " ")
echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load xz/5.2.2
module load SAMTOOLS/1.3
cd ${OUTDIR}Pan_troglodytes_${chimp_name}; samtools merge ${chimp_name}.merged.bam $bams; samtools index ${chimp_name}.merged.bam" > ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_merge.sh
jobname=$(echo ${OUTDIR}Pan_troglodytes_${chimp_name}/qu/${chimp_name}_merge.sh)
chmod 755 $jobname
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.merged.out \
-e ${OUTDIR}Pan_troglodytes_${chimp_name}/out/${chimp_name}.merged.err -n ${chimp_name} -u 8 -t 1 -w 23:30:00
done






