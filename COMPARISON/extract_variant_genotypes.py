#!/usr/bin/python3

import sys
import re
import gzip

"""
This python script takes the information from the panel reference and tries to
obtain only information from variant-non fixed snps in the panel from the
individual that we are studying indicated in the sample_name and print it
in a new files
"""

if len(sys.argv) == 5:
    vcf_input_file = sys.argv[1]
    sample_name = sys.argv[2]
    chrom = sys.argv[3]
    out_file = sys.argv[4]
else:
    sys.exit("The usage should be ./extract_variant_genotypes.py \
    vcf_input_file sample_name out_file")

"""
VARIABLES
"""
Pantro = {}
fixed1 = ["0/0", "./."]
fixed2 = ["1/1", "./."]

#FUNCTIONS

"""
This function has as a target to keep the column positions of all
chimp genotypes and save the one that corresponds to the selected
chimp in the sample name
"""


def create_dictionary_with_index_of_chimps(elements, Pan_dict, sample):
    index_ind = -1
    for element in elements:
        index_ind += 1
        if element.startswith("Pan_troglodytes"):
            Pan_dict[index_ind] = ""
        if element == sample:
            vcf_index = index_ind
    return Pan_dict, vcf_index


"""
This function has as a target to retrieve all
chimp genotypes for each vcf entry
"""


def take_genotypes_from_all_chimps(elements, Pan_dict):
    count = -1
    for element in elements:
        count += 1
        if count in Pan_dict:
            Pan_dict[count] = element.split(":")[0]
    return Pan_dict


"""
This function has as a target to print the selected information
from our chimp only in SNPs which are not fixed
"""


def print_selected_chimp_info(elements, vcf_index, out_f):
    chr = elements[0]
    position = elements[1]
    ID = elements[2]
    REF = elements[3]
    ALT = elements[4]
    GT = elements[vcf_index].split(":")[0]
    print("{}\t{}\t{}\t{}\t{}\t{}".format(chr, position, ID, REF, ALT, GT), file=out_f)


#MAIN

with gzip.open(vcf_input_file, "rt") as f, \
     gzip.open(out_file, "wt") as out_fh:
    for line in f:
        fields = line.rstrip().split()
        if line.startswith("#CHROM"):
            Pantro, analized_vcf_index = \
             create_dictionary_with_index_of_chimps(fields, Pantro, sample_name)
        elif line.startswith("#"):
            continue
        else:
            Pantro = take_genotypes_from_all_chimps(fields, Pantro)
            if all(value in fixed1 for key, value in Pantro.items()) or \
               all(value in fixed2 for key, value in Pantro.items()):
                print(len(Pantro), Pantro)
                continue
            else:
                #print(len(Pantro), Pantro)
                print_selected_chimp_info(fields, analized_vcf_index, out_fh)
