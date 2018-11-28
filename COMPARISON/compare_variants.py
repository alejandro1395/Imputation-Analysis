#!/usr/bin/python3

import sys
import re
import gzip

if len(sys.argv) == 4:
    ref_input_file = sys.argv[1]
    calculated_genotypes = sys.argv[2]
    out_file = sys.argv[3]
else:
    sys.exit("The usage should be ./compare_snps_imputing.py \
    gen_input_file info_input_name ref_file threeshold out_file")

diction = {}
types = []
last_pos = ""
total_both_count = 0
corrected_both_count = 0
corrected_imputed = 0
total_imputed = 0
total_three = 0
corrected_three = 0
variant = False
Nucleotides = ["A", "C", "G", "T"]

with open(calculated_genotypes, "r") as f1:
    next(f1)
    for line in f1:
        fields = line.rstrip().split()
        position = fields[0]
        allele0 = fields[1]
        allele1 = fields[2]
        genotype = fields[3]
        TYPE = int(fields[4])
        if position != last_pos:
            diction[position] = []
            diction[position].append([allele0, allele1, genotype, TYPE])
        else:
            diction[position].append([allele0, allele1, genotype, TYPE])
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
            if pos in diction.keys() and len(alt_list) == 1 \
               and alt_list[0] in Nucleotides and ref in Nucleotides \
               and gt_ref != "." and gt_alt != ".":
                for element in diction[pos]:
                    alleles_gt = element[2].split("/")
                    count = 0
                    if ref in (element[0], element[1]) and (element[0] in alt_list \
                                                            or element[1] in alt_list):
                        variant = True
                        for all in alleles_gt:
                            if ref == all:
                                count += 1
                        if count == 2:
                            gt_imp_ref = "0"
                            gt_imp_alt = "0"
                        elif count == 1:
                            gt_imp_ref = "0"
                            gt_imp_alt = "1"
                        elif count == 0:
                            gt_imp_ref = "1"
                            gt_imp_alt = "1"
                        if variant and (element[3] == 2):
                            total_both_count += 1
                            if gt_imp_ref == gt_ref and gt_imp_alt == gt_alt:
                                corrected_both_count += 1
                            variant = False
                            break
                        elif variant and (element[3] == 3):
                            total_three += 1
                            print(pos, diction[pos], file=f3)
                            if gt_imp_ref == gt_ref and gt_imp_alt == gt_alt:
                                corrected_three += 1
                            variant = False
                            break
                        elif variant and (element[3] == 1):
                            total_imputed += 1
                            if gt_imp_ref == gt_ref and gt_imp_alt == gt_alt:
                                corrected_imputed += 1
                            variant = False
                            break


        print("#####PERCENTAGES OF IMPUTATION SCORES######", file = f3)
        print()
        print("{}: {}".format("Total number of type 3 positions in ref VCF", total_three), file=f3)
        print("{}: {}".format("Total number of type 3 positions in ref VCF right", corrected_three), file=f3)
        print("{}: {}".format("Total number of BOTH panel-down in ref VCF", total_both_count), file=f3)
        print("{}: {}".format("Percentage of right BOTH panel-down in ref VCF genotypes", round(100*(corrected_both_count/total_both_count), 2)), file=f3)
        print("{}: {}".format("Total number of imputed filtered genotypes", total_imputed), file=f3)
        print("{}: {}".format("Percentage of right imputed filtered genotypes", round(100*(corrected_imputed/total_imputed), 2)), file = f3)
