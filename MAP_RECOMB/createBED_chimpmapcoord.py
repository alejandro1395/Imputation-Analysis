#!/usr/bin/python3

import sys
import re
import gzip

if len(sys.argv) == 3:
    chimp_file = sys.argv[1]
    out_BED_file = sys.argv[2]
else:
    sys.exit("The usage should be ./createBED_chimpmapcoord.py \
    chimp_file out_BED_file")

chrom = chimp_file.split("/")[8].split("_")[2].split(".")[0].split("r")[1]
with open(chimp_file, "r") as f, open(out_BED_file, "w") as out_fh:
    for line in f:
        line = line.rstrip()
        fields = line.split("\t")
        if fields[0] != "position":
            print("{}:{}-{}".format(chrom, int(fields[0])-1, int(fields[0])), file=out_fh )
