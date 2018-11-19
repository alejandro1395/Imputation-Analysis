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

first_line = True

with open(zip_4Ner_chr, "r") as f, open(out_cM_file, "w") as out_fh:
    for line in f:
        line = line.rstrip()
        fields = line.split("\t")
        if first_line:
            print("{}\t{}\t{}".format("position", "COMBINED_rate(cM/Mb)",
                                      "Genetic_Map(cM)"), file=out_fh)
            position = int(fields[0])
            combined_rate = float(fields[1])
            gen_map = 0
            print("{}\t{}\t{}".format(position, combined_rate, gen_map), file=out_fh)
            first_line = False
            last_rate = combined_rate
            previous_pos = position
        else:
            position = int(fields[0])
            combined_rate = float(fields[1])
            gen_map += last_rate*(position-previous_pos)/1000000
            print("{}\t{}\t{}".format(position, combined_rate, gen_map), file=out_fh)
            last_rate = combined_rate
            previous_pos = position
