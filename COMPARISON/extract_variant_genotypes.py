#!/usr/bin/python3

import sys
import re
import gzip

if len(sys.argv) == 5:
    vcf_input_file = sys.argv[1]
    sample_name = sys.argv[2]
    chrom = sys.argv[3]
    out_file = sys.argv[4]
else:
    sys.exit("The usage should be ./extract_variant_genotypes.py \
    vcf_input_file sample_name out_file")


with gzip.open(vcf_input_file, "rt") as f, \
     gzip.open(out_file, "wt") as out_fh:
    for line in f:
        fields = line.rstrip().split()
        if line.startswith("#CHROM"):
            index_ind = -1
            for field in fields:
                index_ind += 1
                if field == sample_name:
                    break
        elif line.startswith("#"):
            continue
        else:
            if fields[0] == chrom:
                chr = fields[0]
                position = fields[1]
                ID = fields[2]
                REF = fields[3]
                ALT = fields[4]
                GT_REF = fields[index_ind].split(":")[0].split("/")[0]
                GT_ALT = fields[index_ind].split(":")[0].split("/")[1]
                print("{}\t{}\t{}\t{}\t{}\t{}\t{}".format(chr, position,
                                                          ID, REF, ALT, GT_REF,
                                                          GT_ALT), file=out_fh)
