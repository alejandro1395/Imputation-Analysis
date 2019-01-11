#!/usr/bin/python3


"""
Script for comparing genotypes between the reference high coverage vcf for our chimp and chromosome and 
the output snps of the imputation process carried out by Impute2
"""


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

#DICTIONARIES

dict_known = {}
dict_well_imputed = {}
dict_impute = {}

#VARIABLES

corrected_known = 0
total_known = 0
corrected_imputed = 0
total_imputed = 0
total_impute = 0
found_impute = 0

#FUNCTIONS

"""
Function for saving all information coming
from gen file and info file which result from the IMPUTE2 analysis
on our data
"""

def retrieve_snp_fields_from_gen_file(first_line, second_line):
    fields1 = first_line.rstrip().split()
    fields2 = second_line.rstrip().split()
    chrom = int(fields1[0])
    Ident = fields1[1]
    position = fields1[2]
    reference = fields1[4]
    if reference == "0":
        reference = "."
    alternative = fields1[3]
    if alternative == "0":
        alternative = "."
    Info = float(fields2[6])
    Type = int(fields2[8])
    return chrom, Ident, position, reference, alternative, Info, Type

"""
Function for analyzing the different genotype probbilities and choosing the best one for
comparing it afterwars with the reference high-coverage vcf from the same individual chimp
"""


def find_best_genotype(first_line):
    fields_prob = first_line.rstrip().split()
    probabilities = [float(fields_prob[7]), float(fields_prob[6]), float(fields_prob[5])]
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
    return GT


"""
Function for keeping information coming from the reference VCF of the individual chimp
to compare it
"""

def retrieve_ref_vcf_info(line1):
    fields = line1.rstrip().split()
    posi = fields[1]
    refe = fields[3]
    alte_list = fields[4].split(",")
    gt_refe = fields[5]
    gt_alte = fields[6]
    return posi, refe, alte_list, gt_refe, gt_alte

"""
Function to compare the genotypes between vcf ref and vcf impute2 output and
count the similar ones and the different ones
"""

def compare_gt(dictionary, corrected_dictionary, identifier, gt_refe, gt_alte):
    GT_a0 = dictionary[identifier].split("/")[0]
    GT_a1 = dictionary[identifier].split("/")[1]
    if GT_a0 == gt_refe and GT_a1 == gt_alte:
        corrected_dictionary += 1
    return corrected_dictionary

#MAIN

with gzip.open(gen_input_file, "rt") as f1, \
    open(info_input_name, "r") as f2:
        next(f2)
        for line1, line2 in zip(f1, f2):
            chromosome, ID, pos, ref, alt, INFO, TYPE = retrieve_snp_fields_from_gen_file(line1, line2)
            Genotype = find_best_genotype(line1)
            if INFO >= float(threeshold) and (TYPE == 2 or TYPE == 3):
                dict_known[pos+":"+ref+":"+alt] = Genotype
                total_known += 1
            if INFO >= float(threeshold) and (TYPE == 1):
                dict_well_imputed[pos+":"+ref+":"+alt] = Genotype
                total_imputed += 1
            if (TYPE == 1):
                total_impute += 1
                dict_impute[pos+":"+ref+":"+alt] = 0

with gzip.open(ref_file, "rt") as f3, \
     open(out_file, "w") as f4:
        for line in f3:
            pos, ref, alt_list, gt_ref, gt_alt = retrieve_ref_vcf_info(line)
            for alt in alt_list:
                ident = pos+":"+ref+":"+alt
                if ident in dict_impute.keys():
                    found_impute += 1
                if ident in dict_known.keys():
                    corrected_known = compare_gt(dict_known, corrected_known, ident, gt_ref, gt_alt)
                elif ident in dict_well_imputed.keys():
                    corrected_imputed = compare_gt(dict_well_imputed, corrected_imputed, ident, gt_ref, gt_alt)
        for key in dict_known:
            print(key, file=f4)

        print("There are in total "+str(total_impute)+"but only found"+str(found_impute))
        print("#####PERCENTAGES OF IMPUTATION SCORES######", file = f4)
        print()
        print("{}: {}".format("Total number of before-hand known genotypes", total_known), file=f4)
        print("{}: {}".format("Percentage of right before-hand known genotypes", 100*(corrected_known/total_known)), file=f4)
        print("{}: {}".format("Total number of imputed filtered genotypes", total_imputed), file=f4)
        print("{}: {}".format("Percentage of right imputed filtered genotypes", 100*(corrected_imputed/total_imputed)), file = f4)
        print("There are in total "+str(total_impute)+"imputed positions, but only found"+str(found_impute)+ "match with our individual", file=f4)
