#!/usr/bin/bash

#FOLDER PATH OF CHROMOSOMES

INDIR="/scratch/devel/avalenzu/Impute_Master_Project/results/Impute_out/Pan_troglodytes_central-Nico/chr1/"

for i in {1..250}; 
do cat ${INDIR}chr1.chunk$i.unphased.impute2 >> chr1.all_chunk.unphased.impute2
done
