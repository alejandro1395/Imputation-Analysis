import sys
import re

#DICTIONARY WITH COVERAGES


if len(sys.argv) == 3:
    chr2a = sys.argv[1]
    chr2b = sys.argv[2]
else:
    sys.exit("The usage should be ./integrate \
chr2a chr2b")

dist_other_chr = 0
real_dist = 0
first_line = True

with open(chr2a, "r") as in1_fh:
    for line in in1_fh:
        line = line.rstrip()
        if line.startswith("position"):
            print(line)
            continue
        else:
            fields = line.split()
            print(line)
            last_first_fields = fields

with open(chr2b, "r") as in2_fh:
    for line in in2_fh:
        line = line.rstrip()
        if line.startswith("position"):
            continue
        else:
            fields = line.split()
            if first_line:
                real_dist = float(last_first_fields[2]) + float(fields[2])
                print("{}\t{}\t{}".format(fields[0], fields[1], real_dist))
                previous_dist = float(fields[2])
            else:
                real_dist = float(last_first_fields[2]) + (float(fields[2]) - previous_dist)
                print("{}\t{}\t{}".format(fields[0], fields[1], real_dist))
                previous_dist = float(fields[2])
