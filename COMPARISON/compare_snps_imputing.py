#!/usr/bin/python3

import sys
import re
import gzip

if len(sys.argv) == 6:
    gen_input_file = sys.argv[1]
    info_input_name = sys.argv[2]
    ref_file = sys.argv[3]
    threeshold = sys.argv[4]
    out_file = sys.argv[5]
else:
    sys.exit("The usage should be ./compare_snps_imputing.py \
    gen_input_file info_input_name ref_file threeshold out_file")

dict_known = {}
dict_well_imputed = {}
dict_impute = {}

corrected_known = 0
total_known = 0
corrected_imputed = 0
total_imputed = 0
total_impute = 0
found_impute = 0

with gzip.open(gen_input_file, "rt") as f1, \
    open(info_input_name, "r") as f2:
        next(f2)
        for line1, line2 in zip(f1, f2):
            fields1 = line1.rstrip().split()
            fields2 = line2.rstrip().split()
            chromosome = int(fields1[0])
            ID = fields1[1]
            pos = fields1[2]
            ref = fields1[4]
            if ref == "0":
                ref = "."
            alt = fields1[3]
            if alt == "0":
                alt = "."
            probabilities = [float(fields1[7]), float(fields1[6]),
                             float(fields1[5])]
            maximum_prob = max(probabilities)
            for i, j in enumerate(probabilities):
                if j == maximum_prob:
                    max_index = i
            if max_index == 0:
                GT = "0/0"
            elif max_index == 1:
                GT = "0/1"
            elif max_index == 2:
                GT = "1/1"
            INFO = float(fields2[6])
            TYPE = int(fields2[8])
            if INFO >= float(threeshold) and (TYPE == 2 or TYPE == 3):
                dict_known[pos+":"+ref+":"+alt] = GT
                total_known += 1
            if INFO >= float(threeshold) and (TYPE == 1):
                dict_well_imputed[pos+":"+ref+":"+alt] = GT
                total_imputed += 1
            if (TYPE == 1):
                total_impute += 1
                dict_impute[pos+":"+ref+":"+alt] = 0

with gzip.open(ref_file, "rt") as f3, \
     open(out_file, "w") as f4:
        for line in f3:
            fields = line.rstrip().split()
            pos = fields[1]
            ref = fields[3]
            alt_list = fields[4].split(",")
            gt_ref = fields[5]
            gt_alt = fields[6]
            for alt in alt_list:
                ident = pos+":"+ref+":"+alt
                if ident in dict_impute.keys():
                    found_impute += 1
                if ident in dict_known.keys():
                    GT_a0 = dict_known[ident].split("/")[0]
                    GT_a1 = dict_known[ident].split("/")[1]
                    if GT_a0 == gt_ref and GT_a1 == gt_alt:
                        corrected_known += 1
                elif ident in dict_well_imputed.keys():
                    GT_a0 = dict_well_imputed[ident].split("/")[0]
                    GT_a1 = dict_well_imputed[ident].split("/")[1]
                    if GT_a0 == gt_ref and GT_a1 == gt_alt:
                        corrected_imputed += 1

        print("There are in total "+str(total_impute)+"but only found"+str(found_impute))
        print("#####PERCENTAGES OF IMPUTATION SCORES######", file = f4)
        print()
        print("{}: {}".format("Total number of before-hand known genotypes", total_known), file=f4)
        print("{}: {}".format("Percentage of right before-hand known genotypes", 100*(corrected_known/total_known)), file=f4)
        print("{}: {}".format("Total number of imputed genotypes", total_imputed), file=f4)
        print("{}: {}".format("Percentage of right imputed genotypes", 100*(corrected_imputed/total_imputed)), file = f4)
