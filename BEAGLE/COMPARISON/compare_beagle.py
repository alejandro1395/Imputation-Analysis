#!/usr/bin/python3

import sys
import re
import gzip

"""
This script compares the genotypes between a reference vcf of the chimpanzee and the output coming
from the BEAGLE software in order to know the right imputed positions in our data
"""

if len(sys.argv) == 4:
    ref_input_file = sys.argv[1]
    vcf_out_file = sys.argv[2]
    out_file = sys.argv[3]
else:
    sys.exit("The usage should be ./compare_beagle.py \
    ref_input_file vcf_out_file out_file")


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

def take_info_from_vcf_file(line1, dictionary, last_position):
    fields = line1.rstrip().split()
    position = fields[1]
    allele0 = fields[3]
    allele1 = fields[4]
    if len(fields) == 10 and fields[7][-3:] == "IMP":
        genotype = fields[9].split(":")[0]
        Format_fields = fields[7].split(";")
        if len(Format_fields) == 3:
            TYPE = Format_fields[2]
            INFO = Format_fields[0].split("=")[1]
        else:
            TYPE = "IMP"
            INFO = "none"
    elif len(fields) == 10 and fields[7][-3:] != "IMP":
        genotype = fields[9].split(":")[0]
        TYPE = "none"
        INFO = 1
    elif len(fields) == 9:
        genotype = fields[8].split(":")[0]
        TYPE = "none"
        INFO = 1
    if position != last_position:
        dictionary[position] = []
        dictionary[position].append([allele0, allele1, genotype, TYPE, INFO])
    else:
        dictionary[position].append([allele0, allele1, genotype, TYPE, INFO])
    last_position = position
    return dictionary, last_position

"""
Function that takes fields from the reference file coming from the vcf panel after removing it
and preparing it for comparing with BEAGLE result
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

def sum_counter_genotype_found(total_count, correct_count, gt_refe, vcf_gen, gt_alte, variant):
    total_count += 1
    al1 = vcf_gen.split("|")[0]
    al2 = vcf_gen.split("|")[1]
    if al1!="0" or al2!="0":
        if (al1 == gt_refe and al2 == gt_alte) or (al2 == gt_refe and al1 == gt_alte):
            correct_count += 1
    variant = False
    return total_count, correct_count, variant



#MAIN

with gzip.open(vcf_out_file, "rt") as f1:
    for line in f1:
        if not line.startswith("#"):
            diction, last_pos = take_info_from_vcf_file(line, diction, last_pos)


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
                    count = 0
                    if ref in (element[0], element[1]) and (element[0] in alt_list \
                                                            or element[1] in alt_list \
                                                            or "." in (element[0], element[1])):
                        variant = True
                        if variant and (element[3] == "IMP"):
                            total_imputed, corrected_imputed, variant = sum_counter_genotype_found(total_imputed, corrected_imputed,
                                                                                                   gt_ref, element[2], gt_alt, variant)
                            print(pos, element[4], diction[pos], gt_ref, gt_alt, file=f3)
                            break
                        elif variant and (element[3] != "IMP"):
                            total_both_count, corrected_both_count, variant = sum_counter_genotype_found(total_both_count, corrected_both_count,
                                                                                                   gt_ref, element[2], gt_alt, variant)
                            print(pos, element[4], diction[pos], gt_ref, gt_alt, file=f3)
                            break



        print("#####PERCENTAGES OF IMPUTATION SCORES######", file = f3)
        print()
        print("{}: {}".format("Total number of BOTH panel-down in ref VCF", total_both_count), file=f3)
        print("{}: {}".format("Percentage of right BOTH panel-down in ref VCF genotypes", round(100*(corrected_both_count/total_both_count), 2)), file=f3)
        print("{}: {}".format("Total number of imputed filtered genotypes", total_imputed), file=f3)
        print("{}: {}".format("Percentage of right imputed filtered genotypes", round(100*(corrected_imputed/total_imputed), 2)), file = f3)
