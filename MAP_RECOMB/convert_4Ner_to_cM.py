#!/usr/bin/python3

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


with gzip.open(zip_4Ner_chr, "rt") as f, open(out_cM_file, "w") as out_fh:
    for line in f:
        line = line.rstrip()
        fields = line.split("\t")
        if fields[0] == "Position(bp)":
            print("{}\t{}\t{}".format("position", "COMBINED_rate(cM/Mb)",
                                      "Genetic_Map(cM)"), file=out_fh)
        else:
            position =int(fields[0].replace(" ", ""))
            rate = (float(fields[1])*100000)/(4*Ne)
            genetic_map = (float(fields[2])*100)/(4*Ne)
            print("{}\t{}\t{}".format(position, rate,
                                      genetic_map), file=out_fh)
