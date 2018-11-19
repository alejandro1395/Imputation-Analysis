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

first_line = True

with open(Ner_chr, "r") as f, open(out_cM_file, "w") as out_fh:
    for line in f:
        line = line.rstrip()
        fields = line.split("\t")
        if first_line:
            print("{}\t{}".format("position", "COMBINED_rate(cM/Mb)"), file=out_fh)
            position = int(fields[2])
            rate = fields[8].replace(",", ".")
            combined_rate = float(rate)*(100000/(4*Ne))
            gen_map = combined_rate*(position/1000000)
            print("{}\t{}".format(position, combined_rate), file=out_fh)
            first_line = False
        else:
            position = int(fields[2])
            rate = fields[8].replace(",", ".")
            combined_rate = float(rate)*(100000/(4*Ne))
            gen_map += combined_rate
            print("{}\t{}".format(position, combined_rate), file=out_fh)
