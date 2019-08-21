#!/usr/bin/env python
#python bwa_gs.py </path/to/fastq.gz> </path/to/BWAIndex/genome.fa> <threads>
import sys
import glob
import os
files = glob.glob(sys.argv[1] + '/*_R1*fastq.gz.trim')
print len(files)
for ifile in files:
        os.system('bwa mem -t %s %s %s %s > %s.sam'  % (sys.argv[3],sys.argv[2],ifile, ifile.replace("R1", "R2"), ifile.split("/")[-1].split("_R1")[0]))





