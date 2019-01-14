#!/usr/bin/bash

#FOLDER PATH OF CHROMOSOMES
coverages="0.006 0.036 0.056 0.076 0.106 0.35"

echo $coverages | tr " " "\n" | while read cov;
do INDIR=/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/results/Impute_out/Pan_troglodytes_verus-McVean/chr22/down_${cov}/

for i in {1..53}; 
do cat ${INDIR}filtered_filtered_panel_chr22.chunk$i.unphased.impute2.gz >> ${INDIR}filtered_filtered_panel_chr22.all.unphased.impute2.gz
done

for i in {1..53};
do cat ${INDIR}filtered_filtered_panel_chr22.chunk$i.unphased.impute2_info | tail -n+2 >> ${INDIR}filtered_filtered_panel_chr22.all.unphased.impute2_info
done; done
