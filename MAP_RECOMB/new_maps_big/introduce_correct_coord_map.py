#!/usr/bin/python3


"""
Script that joins information between the liftover coordinates remaining and the genetic map
distances of the chimp recombination maps produced by LdHat
"""

import sys
import re
import fileinput

if len(sys.argv) == 5:
    unmapped = sys.argv[1]
    converted = sys.argv[2]
    genetic_map = sys.argv[3]
    chr = sys.argv[4]
else:
    sys.exit("The usage should be ./convert_4Ner_to_cM.py \
    zip_4Ner_chr Ne out_cM_file")

#VARIABLES

converted_read = True
previous = 0

#FUNCTIONS

"""
Function that creates a list where all the excluded positions are saved for joining
the coordinates with the map distances later
"""

def create_excluded_positions_list(file_unmapped):
    Excluded_list = []
    with open(file_unmapped, "r") as in_fh:
    for line in in_fh:
        line = line.rstrip()
        if not line.startswith("#"):
            chr_coord = int(line.split()[2])
            Excluded_list.append(chr_coord)
    return Excluded_list

"""
Function that runs if the position in the liftover analysis has been unmapped
and does not print the next coordinate in the map until the next position has been
mapped with the lift over
"""

def unmapped_reads_skipping(input2_fh, Excluded_list, fields_second_file, position):
    unmapped_read = True
    while unmapped_read:
        line1 = next(input2_fh)
        fields1 = line1.rstrip().split()
        if (fields1[1] not in Excluded_list) and (fields_second_file[0] == chr):
            print("{}\t{}".format(fields_second_file[2], fields1[2]))
            unmapped_read = False
            previous_pos = position
            break
        elif (fields1[1] not in Excluded_list) and (fields_second_file[0] != chr):
            previous_pos = position
            break
    return previous_pos

"""
Function that retrieves the fields for both files at the same time,
the old genetic map and the genomic coordinates after LiftOver
process
"""


def getting_line_fields_2_zip_files(first_line, second_line):
    first_line = first_line.rstrip()
    second_line = second_line.rstrip()
    fields_first = first_line.split()
    fields_second = second_line.split()
    return fields_first, fields_second

#MAIN SCRIPT

Excluded = create_excluded_positions_list(unmapped)

with open(genetic_map, "r") as in2_fh:
    with open(converted, "r") as in3_fh:
        for line1, line2 in zip(in2_fh, in3_fh):
            fields1, fields2 = getting_line_fields_2_zip_files(line1, line2)
            pos = int(fields2[2])
            if pos > previous:
                if (fields1[1] not in Excluded) and (fields2[0] == chr):
                    print("{}\t{}".format(fields2[2], fields1[2]))
                    previous = pos
                    continue
                else:
                    if fields1[1] in Excluded:
                        previous = unmapped_reads_skipping(in2_fh, Excluded, fields2, pos)
            else:
                next(in2_fh)
                next(in3_fh)
