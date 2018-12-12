#!/usr/bin/python3

import sys
import re
import gzip

"""
This script compares the genotypes between a reference vcf of the chimpanzee and the output coming
from the IMPUTE2 software in order to know the right imputed positions in our data
"""

if len(sys.argv) == 4:
    ref_input_file = sys.argv[1]
    calculated_genotypes = sys.argv[2]
    out_file = sys.argv[3]
else:
    sys.exit("The usage should be ./compare_snps_imputing.py \
    gen_input_file info_input_name ref_file threeshold out_file")


#VARIABLES
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

#FUNCTIONS

"""
Function that takes fields from the genotype calculated file coming from impute2 output
"""

def take_info_from_genotyped_file(line1, dictionary, last_position):
    fields = line1.rstrip().split()
    position = fields[0]
    allele0 = fields[1]
    allele1 = fields[2]
    genotype = fields[3]
    TYPE = int(fields[4])
    if position != last_position:
        dictionary[position] = []
        dictionary[position].append([allele0, allele1, genotype, TYPE])
    else:
        dictionary[position].append([allele0, allele1, genotype, TYPE])
    last_position = position
    return dictionary, last_position

"""
Function that takes fields from the reference file coming from the vcf panel after removing it
and preparing it for comparing rith impute2 result
"""

def take_info_from_reference_file(line2):
    fields = line2.rstrip().split()
    posi = fields[1]
    refe = fields[3]
    alte_list = fields[4].split(",")
    gt_refe = fields[5]
    return posi, refe, alte_list, gt_refe

"""
Functions that translate impute2 genotypes to vcf 0/1 format for biallelic SNPs found
with the software
"""

def translate_to_vcf_genotype(all_gt, refe, counter):
    for all in all_gt:
        if refe == all:
            counter += 1
    if counter == 2:
        gt_imp_refe = "0"
        gt_imp_alte = "0"
    elif counter == 1:
        gt_imp_refe = "0"
        gt_imp_alte = "1"
    elif counter == 0:
        gt_imp_refe = "1"
        gt_imp_alte = "1"
    return gt_imp_refe, gt_imp_alte

"""
FUNCTION for suming the genotype count and matches of each type of snp
determined by IMPUTE2
"""

def sum_counter_genotype_found(total_count, correct_count, gt_imp_refe, gt_refe, gt_imp_alte, gt_alte, variant):
    total_count += 1
    if gt_imp_refe == gt_refe and gt_imp_alte == gt_alte:
        correct_count += 1
    variant = False
    return total_count, correct_count, variant



#MAIN

with open(calculated_genotypes, "r") as f1:
    next(f1)
    for line in f1:
        diction, last_pos = take_info_from_genotyped_file(line, diction, last_pos)


with gzip.open(ref_input_file, "rt") as f2, \
     open(out_file, "w") as f3:
        for line in f2:
            pos, ref, alt_list, gt = take_info_from_reference_file(line)
            gt_ref = gt.split("/")[0]
            gt_alt = gt.split("/")[1]
            if pos in diction.keys() and len(alt_list) == 1 \
               and alt_list[0] in Nucleotides and ref in Nucleotides \
               and gt != "./.":
                for element in diction[pos]:
                    alleles_gt = element[2].split("/")
                    count = 0
                    if ref in (element[0], element[1]) and (element[0] in alt_list \
                                                            or element[1] in alt_list \
                                                            or "." in (element[0], element[1])):
                        variant = True
                        gt_imp_ref, gt_imp_alt = translate_to_vcf_genotype(alleles_gt, ref, count)
                        if variant and (element[3] == 2):
                            #print(pos, diction[pos], file=f3)
                            total_both_count, corrected_both_count, variant = sum_counter_genotype_found(total_both_count,
                                                                                                         corrected_both_count,
                                                                                                         gt_imp_ref, gt_ref, gt_imp_alt,
                                                                                                         gt_alt, variant)
                            break
                        elif variant and (element[3] == 3):
                            #print(pos, diction[pos], file=f3)
                            total_three, corrected_three, variant = sum_counter_genotype_found(total_three, corrected_three,
                                                                                                gt_imp_ref, gt_ref, gt_imp_alt,
                                                                                                gt_alt, variant)
                            if gt_imp_ref != gt_ref or gt_imp_alt != gt_alt:
                                print(pos, diction[pos])

                            break
                        elif variant and (element[3] == 1):
                            total_imputed, corrected_imputed, variant = sum_counter_genotype_found(total_imputed, corrected_imputed,
                                                                                                gt_imp_ref, gt_ref, gt_imp_alt,
                                                                                                gt_alt, variant)
                            break


        print("#####PERCENTAGES OF IMPUTATION SCORES######", file = f3)
        print()
        print("{}: {}".format("Total number of type 3 positions in ref VCF", total_three), file=f3)
        print("{}: {}".format("Total number of type 3 positions in ref VCF right", corrected_three), file=f3)
        print("{}: {}".format("Total number of BOTH panel-down in ref VCF", total_both_count), file=f3)
        print("{}: {}".format("Percentage of right BOTH panel-down in ref VCF genotypes", round(100*(corrected_both_count/total_both_count), 2)), file=f3)
        print("{}: {}".format("Total number of BOTH panel-down in ref VCF", total_both_count + total_three), file=f3)
        print("{}: {}".format("Percentage of right BOTH panel-down in ref VCF genotypes", round(100*((corrected_three+corrected_both_count)/(total_both_count + total_three)), 2)), file=f3)
        print("{}: {}".format("Total number of imputed filtered genotypes", total_imputed), file=f3)
        print("{}: {}".format("Percentage of right imputed filtered genotypes", round(100*(corrected_imputed/total_imputed), 2)), file = f3)
