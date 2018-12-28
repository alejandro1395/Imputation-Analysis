#!/usr/bin/bash

#FOLDER PATH OF CHROMOSOMES

INDIR="/scratch/devel/avalenzu/Impute_Master_Project/results/Impute_out/Pan_troglodytes_verus-McVean/chr22/down_0.036/"

for i in {1..53}; 
do cat ${INDIR}filtered_chr22.chunk$i.unphased.impute2.gz >> ${INDIR}filtered_chr22_prueba.all.unphased.impute2.gz
done

for i in {1..53};
do cat ${INDIR}filtered_chr22.chunk$i.unphased.impute2_info | tail -n+2 >> ${INDIR}filtered_chr22_prueba.all.unphased.impute2_info
done
