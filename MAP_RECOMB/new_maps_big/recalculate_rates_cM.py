#!/usr/bin/python3


"""
This script take the genetic map distances from the fine-scale recombination map from chimp 
and calculate their rates according to the genetic distances between positions, the rate 
between two syntenic blocks in the chimp chromosome (MAPPED to human genome) is not calculated
"""

import sys
import re
import gzip

if len(sys.argv) == 4:
    Ner_chr = sys.argv[1]
    Ne = int(sys.argv[2])
    out_cM_file = sys.argv[3]
else:
    sys.exit("The usage should be ./convert_4Ner_to_cM.py \
    Ner_chr Ne out_cM_file")

#VARIABLES
first_line = True

#FUNCTIONS

"""
This function keeps the info coming from the map file of distance and position and keeps it
in a variable to compute the rate substracting it to the following distance and position in
the file
"""

def get_previous_pos_and_mapdis_to_calculated_rate(fields_info, effective_size):
    previous_pos = int(fields_info[0])
    prev_gen_map_dis = (float(fields_info[1])*100)/(4*effective_size)
    return previous_pos, prev_gen_map_dis
    
#MAIN

with open(Ner_chr, "r") as f, open(out_cM_file, "w") as out_fh:
    for line in f:
        line = line.rstrip()
        fields = line.split("\t")
        if first_line:
            print("{}\t{}\t{}".format("position", "COMBINED_rate(cM/Mb)",
                                      "Genetic_Map(cM)"), file=out_fh)
            first_line = False
            previous, prev_gen_map = get_previous_pos_and_mapdis_to_calculated_rate(fields, Ne)
        else:
            position = int(fields[0])
            range = (position - previous)/1000000
            genetic_map = (float(fields[1])*100)/(4*Ne)
            if genetic_map < prev_gen_map:
                previous, prev_gen_map = get_previous_pos_and_mapdis_to_calculated_rate(fields, Ne)
            else:
                real_dist = genetic_map - prev_gen_map
                rate = abs(real_dist)/range
                print("{}\t{}".format(previous, rate), file=out_fh)
                previous, prev_gen_map = get_previous_pos_and_mapdis_to_calculated_rate(fields, Ne)
