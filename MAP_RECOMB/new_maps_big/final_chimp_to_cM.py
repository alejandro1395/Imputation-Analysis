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
    zip_4Ner_chr Ne out_cM_file")


with open(Ner_chr, "r") as f, open(out_cM_file, "w") as out_fh:
    for line in f:
        line = line.rstrip()
        fields = line.split("\t")
        if fields[0] == "position":
            print(line, file=out_fh)
            line = next(f)
            line = line.rstrip()
            fields = line.split("\t")
            position =int(fields[0])
            rate = float(fields[1])
            genetic_map = 0.0
            print("{}\t{}\t{}".format(position, rate,
                                      genetic_map), file=out_fh)
            last_rate = rate
            previous_pos = position
        else:
            position = int(fields[0])
            rate = float(fields[1])
            genetic_map += last_rate*(position-previous_pos)/1000000
            print("{}\t{}\t{}".format(position, rate, genetic_map), file=out_fh)
            last_rate = rate
            previous_pos = position
