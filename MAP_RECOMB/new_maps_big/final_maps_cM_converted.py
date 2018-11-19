#!/usr/bin/python3

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

first_line = True

with open(Ner_chr, "r") as f, open(out_cM_file, "w") as out_fh:
    for line in f:
        line = line.rstrip()
        fields = line.split("\t")
        if first_line:
            print("{}\t{}\t{}".format("position", "COMBINED_rate(cM/Mb)",
                                      "Genetic_Map(cM)"), file=out_fh)
            first_line = False
            previous = int(fields[0])
            prev_gen_map = (float(fields[1])*100)/(4*Ne)
            print_gen_map = (float(fields[1])*100)/(4*Ne)
            line = next(f)
        line = line.rstrip()
        fields = line.split("\t")
        position = int(fields[0])
        range = (position - previous)/1000000
        genetic_map = (float(fields[1])*100)/(4*Ne)
        real_dist = genetic_map - prev_gen_map
        rate = abs(real_dist)/range
        print_gen_map += abs(real_dist)
        print("{}\t{}\t{}".format(previous, rate,
                                  print_gen_map), file=out_fh)
        previous = int(fields[0])
        prev_gen_map = (float(fields[1])*100)/(4*Ne)
