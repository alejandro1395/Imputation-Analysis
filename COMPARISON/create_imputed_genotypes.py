#!/usr/bin/python3

import sys
import re
import gzip

if len(sys.argv) == 5:
    gen_input_file = sys.argv[1]
    info_input_name = sys.argv[2]
    calculated_genotypes = sys.argv[3]
    threeshold = sys.argv[4]
else:
    sys.exit("The usage should be ./compare_snps_imputing.py \
    gen_input_file info_input_name ref_file threeshold out_file")

dict_known = {}
dict_well_imputed = {}
dict_impute = {}
dict_count = {}

corrected_known = 0
total_known = 0
corrected_imputed = 0
total_imputed = 0
last_pos = ""

with gzip.open(gen_input_file, "rt") as f1, \
     open(info_input_name, "r") as f2, \
     open(calculated_genotypes, "w") as f3:
        print("{}\t{}\t{}\t{}\t{}".format("position", "allele1", "allele2", "genotype", "SNP_type"), file=f3)
        for line1, line2 in zip(f1, f2):
            fields1 = line1.rstrip().split()
            fields2 = line2.rstrip().split()
            chromosome = int(fields1[0])
            pos = fields1[2]
            allele0 = fields1[3]
            if allele0 == "0":
                allele0 = "."
            allele1 = fields1[4]
            if allele1 == "0":
                allele1 = "."
            probabilities = [float(fields1[5]), float(fields1[6]),
                             float(fields1[7])]
            maximum_prob = max(probabilities)
            for i, j in enumerate(probabilities):
                if j == maximum_prob:
                    max_index = i
            if max_index == 0:
                GT = allele0+"/"+allele0
            elif max_index == 1:
                GT = allele0+"/"+allele1
            elif max_index == 2:
                GT = allele1+"/"+allele1
            INFO = float(fields2[6])
            TYPE = int(fields2[8])
            if INFO >= float(threeshold):
                print("{}\t{}\t{}\t{}\t{}".format(pos, allele0, allele1, GT, TYPE), file=f3)
