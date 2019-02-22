#!/usr/bin/python3

import sys
import re
import gzip

"""
This script compares the genotypes between a reference vcf of the Human and the output coming
from the BEAGLE software in order to know the right imputed positions in our data
"""

if len(sys.argv) == 5:
    vcf_out_file = sys.argv[1]
    low_cov_vcf_file = sys.argv[2]
    sample_name = sys.argv[3]
    out_file = sys.argv[4]
else:
    sys.exit("The usage should be ./compare_beagle.py \
     vcf_out_file low_cov_vcf_file out_file")


#VARIABLES
imputed_gens = {}
missings = {}
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
This function has as a target to keep the column positions of all
chimp genotypes and save the one that corresponds to the selected
chimp in the sample name
"""


def retrieve_index_of_chimp_sample(line1, sample):
    index_ind = -1
    fields = line1.rstrip().split()
    for element in fields:
        index_ind += 1
        if element == sample:
            vcf_index = index_ind
    return vcf_index


"""
Keep missing values from the original low-coverage vcf files
"""

def take_info_from_lowcov_vcf_file(line1, missings_dict, index1):
    fields = line1.rstrip().split()
    position = fields[1]
    allele0 = fields[3]
    allele1 = fields[4]
    genotype = fields[index1].split(":")[0]
    if genotype == "./.":
        missings_dict[position] = [allele0, allele1]
    return missings_dict


"""
Function that takes fields from the genotype calculated file coming from Beagle output
where missing values were found at the beginning (with qualimp > 0.3)
"""


def take_info_from_beagle_vcf_file_and_print(line1, missings_dict, imputed_dict, index2, out_filehandle):
    fields = line1.rstrip().split()
    position = fields[1]
    allele0 = fields[3]
    allele1 = fields[4]
    Format_fields = fields[7].split(";")
    r_square = float(Format_fields[1].split("=")[1])
    if r_square >= 0.3:
        if position in missings_dict and \
           (allele0 in missings_dict[position] and allele1 in missings_dict[position]):
            genotype = fields[index2].split(":")[0]
            print("{}\t{}\t{}\t{}".format(position, r_square,
            genotype.split("|")[0], genotype.split("|")[1]),
            file=out_filehandle)


'''
Function that takes fields from the reference file coming from the vcf panel after removing it
and preparing it for comparing with BEAGLE result
def take_info_from_reference_file_and_print_to_out(line2, index3, out_filehandle, imputed_dict):
    fields = line2.rstrip().split()
    posi = fields[1]
    refe = fields[3]
    alte_list = fields[4].split(",")
    gt = fields[index3].split(":")[0]
    if posi in imputed_dict and refe in Nucleotides and all(element in Nucleotides for element in alte_list):
        genotype = imputed_dict[posi][0]
        print("{}\t{}\t{}\t{}\t{}\t{}".format(posi, imputed_dict[posi][1], genotype.split("|")[0], genotype.split("|")[1], gt.split("|")[0], gt.split("|")[1]), file=out_filehandle)
Functions that translate impute2 genotypes to vcf 0/1 format for biallelic SNPs found
with the software
'''

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
    if (al1 == gt_refe and al2 == gt_alte):
        correct_count += 1
    variant = False
    return total_count, correct_count, variant, al1, al2


#MAIN

"""
FIRST WE ACCOUNT THE POSITIONS UNGENOTYPED FOR THE sample
"""



with gzip.open(low_cov_vcf_file, "rt") as f1:
    for line in f1:
        if line.startswith("#CHROM"):
            sample_index1 = retrieve_index_of_chimp_sample(line, sample_name)
        if not line.startswith("#"):
            missings = take_info_from_lowcov_vcf_file(line, missings, sample_index1)

"""
THEN WE RETRIEVE THE GENOTYPES FOR THOSE POSITIONS AFTER IMPUTATION
"""

with gzip.open(vcf_out_file, "rt") as f2, \
     open(out_file, "w") as f4:
        for line in f2:
            if line.startswith("#CHROM"):
                sample_index2 = retrieve_index_of_chimp_sample(line, sample_name)
            if not line.startswith("#"):
                take_info_from_beagle_vcf_file_and_print(line, missings, imputed_gens, sample_index2, f4)

"""
NOW we print the positions in the reference 1000Gpanel with our POSITIONS
and print the result in an output file with the R2 values


with gzip.open(ref_input_file, "rt") as f3, \
     open(out_file, "w") as f4:
        for line in f3:
            if line.startswith("#CHROM"):
                sample_index3 = retrieve_index_of_chimp_sample(line, sample_name)
            if not line.startswith("#"):
                take_info_from_reference_file_and_print_to_out(line, sample_index3, f4, imputed_gens)

"""
