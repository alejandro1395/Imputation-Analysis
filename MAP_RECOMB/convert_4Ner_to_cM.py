#!/usr/bin/python3

"""
This script converts the units of the recombination genetic maps produced by the software of LdHat across the genome into cM units
so we can construct a fine-scale recombination map for the Imputation analysis
"""

import sys
import re
import gzip

if len(sys.argv) == 4:
    zip_4Ner_chr = sys.argv[1]
    Ne = int(sys.argv[2])
    out_cM_file = sys.argv[3]
else:
    sys.exit("The usage should be ./convert_4Ner_to_cM.py \
    zip_4Ner_chr Ne out_cM_file")

    
#FUNCTIONS

"""
This function is the one that takes the values from the LdHat software and
computes the transformation in order to print it correctly
"""

def score_genetic_distances_in_cM(info_fields, Effective_size):
    pos_field =int(info_fields[0].replace(" ", ""))
    rate_field = (float(info_fields[1])*100000)/(4*Effective_size)
    genetic_map_field = (float(info_fields[2])*100)/(4*Effective_size)
    return pos_field, rate_field, genetic_map_field
    

#MAIN SCRIPT

with gzip.open(zip_4Ner_chr, "rt") as f, open(out_cM_file, "w") as out_fh:
    for line in f:
        line = line.rstrip()
        fields = line.split("\t")
        if fields[0] == "Position(bp)":
            print("{}\t{}\t{}".format("position", "COMBINED_rate(cM/Mb)",
                                      "Genetic_Map(cM)"), file=out_fh)
        else:
            position, rate, genetic_map = score_genetic_distances_in_cM(fields, Ne)
            print("{}\t{}\t{}".format(position, rate,
                                      genetic_map), file=out_fh)
