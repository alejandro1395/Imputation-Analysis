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

if len(sys.argv) == 7:
    vcf_input_file = sys.argv[1]
    vcf_panelfilt_file = sys.argv[2]
    sample_name = sys.argv[3]
    file_samples_to_exclude = sys.argv[4]
    chrom = sys.argv[5]
    out_file = sys.argv[6]
else:
    sys.exit("The usage should be ./extract_variant_genotypes.py \
    vcf_input_file sample_name out_file")

"""
VARIABLES
"""
Pantro = {}
Pantro_pos = {}
fixed1 = ["0/0", "./."]
fixed2 = ["1/1", "./."]
Nucleotides = ["A", "C", "G", "T"]
non_biallelic = [str(i) for i in range(2, 10)]
with open(file_samples_to_exclude, "r") as in_ex:
    samples_to_exclude = [line.rstrip() for line in in_ex]

#FUNCTIONS

"""
This function has as a target to keep the column positions of all
chimp genotypes and save the one that corresponds to the selected
chimp in the sample name
"""

def create_dictionary_with_positions_filtered(elements, Pan_dict, Nucl):
    if elements[3] in Nucl and elements[4] in Nucl:
        Pan_dict[elements[1]] = [elements[3], elements[4]]
    return Pan_dict


def create_dictionary_with_index_of_chimps(elements, Pan_dict, sample):
    index_ind = -1
    for element in elements:
        index_ind += 1
        if element.startswith("Pan_troglodytes") and element not in samples_to_exclude:
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


def print_selected_chimp_info(elements, vcf_index, min_val, miss, maf, out_f):
    chr = elements[0]
    position = elements[1]
    ID = elements[2]
    REF = elements[3]
    ALT = elements[4]
    GT = elements[vcf_index].split(":")[0]
    print("{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}".format(chr, position, ID, REF, ALT, GT, min_val, miss, maf), file=out_f)


#MAIN

with gzip.open(vcf_panelfilt_file, "rt") as f1:
    for line in f1:
        if not line.startswith("#"):
            fields = line.rstrip().split()
            Pantro_pos = create_dictionary_with_positions_filtered(fields, Pantro_pos, Nucleotides)


with gzip.open(vcf_input_file, "rt") as f2, \
     gzip.open(out_file, "wt") as out_fh:
    print("{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}".format("chr", "position", "ID", "REF", "ALT", "GT", "min_count", "missingness", "maf"), file=out_fh)
    for line in f2:
        fields = line.rstrip().split()
        if line.startswith("#CHROM"):
            Pantro, analized_vcf_index = \
             create_dictionary_with_index_of_chimps(fields, Pantro, sample_name)
        elif line.startswith("#"):
            continue
        else:
            if fields[1] in Pantro_pos and fields[3] in Pantro_pos[fields[1]] and fields[4] in Pantro_pos[fields[1]]:
                print(fields[1])
                Pantro = take_genotypes_from_all_chimps(fields, Pantro)
                if all(value in fixed1 for key, value in Pantro.items()) or \
                   all(value in fixed2 for key, value in Pantro.items()) or \
                   any(value.split("/")[0] in str(range(2, 9)) for key, value in Pantro.items()) or \
                   any(value.split("/")[1] in str(range(2, 9)) for key, value in Pantro.items()):
                    continue
                else:
                    count_0 = 0
                    count_1 = 0
                    total = 0
                    count_missing = 0
                    for key, value in Pantro.items():
                        if value == "./.":
                            count_missing += 1
                        alleles = value.split("/")
                        for al in alleles:
                            total += 1
                            if al == "0":
                                count_0 += 1
                            elif al == "1":
                                count_1 += 1
                    minim = min(count_0, count_1)
                    maf_val = minim/total
                    missingness = count_missing/len(Pantro)
                    #print(Pantro, fields[0], fields[1], analized_vcf_index, fields[analized_vcf_index], minim)
                    print_selected_chimp_info(fields, analized_vcf_index, minim, missingness, maf_val, out_fh)
