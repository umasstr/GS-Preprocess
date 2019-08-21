#!/usr/bin/env python
import glob
import os
import sys
files = glob.glob(sys.argv[1] + '/*_R1*fastq.gz')
for ifile in files:
    os.system("cutadapt -b TTGAGTTGTCATATGTTAATAACGGTAT -b ACATATGACAACTCAATTAAAC -b ATACCGTTATTAACATATGACAACTCAA -b GTTTAATTGAGTTGTCATATGT -B TTGAGTTGTCATATGTTAATAACGGTAT -B ACATATGACAACTCAATTAAAC -B ATACCGTTATTAACATATGACAACTCAA -B GTTTAATTGAGTTGTCATATGT -o %s.trim -p %s.trim %s %s" % (ifile, ifile.replace("R1","R2"),ifile, ifile.replace("R1","R2")))