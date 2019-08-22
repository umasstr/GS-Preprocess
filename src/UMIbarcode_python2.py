#!/usr/bin/env python2

import itertools
import gzip
import sys

infile = sys.argv[1]  # 'testGetUmi.fastq'

if not infile:
    raise ValueError('No input file given')

open_func = gzip.open if infile.endswith('.gz') else open


with open_func(infile) as f:
    f1, f2 = itertools.tee(f)

    fourth_lines = (
        line.split()[0]
        for line in itertools.islice(f1, 0, None, 4)
    )

    fifth_lines = (
        line[0:7] if line[0:7] else ''
        for line in itertools.islice(f2, 1, None, 4)
    )

    for i, j in zip(fourth_lines, fifth_lines):
        print i, '\t', j