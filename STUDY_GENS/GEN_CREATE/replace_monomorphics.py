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

if len(sys.argv) == 4:
    gen_input_file = sys.argv[1]
    panel_info = sys.argv[2]
    out_file = sys.argv[3]
else:
    sys.exit("The usage should be ./extract_variant_genotypes.py \
    vcf_input_file sample_name out_file")

"""
VARIABLES
"""
Pantro = {}
Nucleotides = ["A", "C", "G", "T"]

#FUNCTIONS


def take_info_from_panel(line1):
    fields = line1.rstrip().split()
    position = fields[1]
    ID = fields[2]
    REF = fields[3]
    ALT = fields[4].split(",")
    return position, REF, ALT


def take_info_from_gen_file(line1):
    fields = line1.rstrip().split()
    position = fields[1]
    ID = fields[2]
    REF = fields[3]
    ALT = fields[4].split(",")
    return position, REF, ALT


def print_fields_of_new_gen_file(ini, end, fields_file, out_file):
    for i in range(ini, end):
        print("{} ".format(fields_file[i]), file=out_file)


#MAIN


with gzip.open(panel_info, "rt") as f1:
    for line in f1:
        pos, ref, alt_list = take_info_from_panel(line)
        if len(alt_list) == 1 \
           and alt_list[0] in Nucleotides and ref in Nucleotides:
            Pantro[pos] = alt_list[0]


with gzip.open(gen_input_file, "rt") as f2, \
     gzip.open(out_file, "wt") as out_fh:
    for line in f2:
        fields_gen = line.rstrip().split()
        pos = fields_gen[2]
        position_alt = fields_gen[3]
        if pos in Pantro and position_alt == "0":
            new_pos_alt = Pantro[pos]
            print_fields_of_new_gen_file(0, 3, fields_gen, out_fh)
            print("{} ".format(new_pos_alt), file=out_fh)
            print_fields_of_new_gen_file(4, 8, fields_gen, out_fh)
