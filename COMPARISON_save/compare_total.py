#!/usr/bin/python3

import sys
import re
import gzip

if len(sys.argv) == 4:
    ref_input_file = sys.argv[1]
    info_file = sys.argv[2]
    out_file = sys.argv[3]
else:
    sys.exit("The usage should be ./compare_snps_imputing.py \
    gen_input_file info_input_name ref_file threeshold out_file")

diction = {}
types = []
last_pos = ""
corrected_known = 0
total_imputed_count = 0
corrected_imputed = 0
total_imputed_in_target_chimp = 0
variant = False

with open(info_file, "r") as f1:
    for line in f1:
        fields = line.rstrip().split()
        position = fields[2]
        allele0 = fields[3]
        allele1 = fields[4]
        TYPE = int(fields[8])
        if position != last_pos and TYPE == 1:
            diction[position] = []
            diction[position].append([allele0, allele1, TYPE])
            total_imputed_count += 1
            last_pos = position
        elif position == last_pos and TYPE == 1:
            diction[position].append([allele0, allele1, TYPE])
            total_imputed_count += 1
            last_pos = position


with gzip.open(ref_input_file, "rt") as f2, \
     open(out_file, "w") as f3:
        for line in f2:
            fields = line.rstrip().split()
            pos = fields[1]
            ref = fields[3]
            alt_list = fields[4].split(",")
            gt_ref = fields[5]
            gt_alt = fields[6]
            if pos in diction.keys():
                for element in diction[pos]:
                    if diction[pos][2] == 1:
                        total_imputed_in_target_chimp += 1


        print("{}: {}".format("Total imputed positions", total_imputed_count), file=f3)
        print("{}: {}".format("Proportion of total imputed in chimp", round(100*(total_imputed_in_target_chimp/total_imputed_count), 2)), file=f3)
