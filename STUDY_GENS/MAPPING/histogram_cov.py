#!/usr/bin/python3

import sys
import re
import fileinput

#DICTIONARY WITH COVERAGES
covs = {}

for line in fileinput.input():
    coverage = line.rstrip().split()[2]
    if coverage not in covs:
        covs[coverage] = 0
    covs[coverage] += 1

for c in covs:
    print("{}\t{}".format(c, covs[c]))
