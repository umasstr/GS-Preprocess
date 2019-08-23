#!/bin/bash
#
module add bcl2fastq2/2.20.0
#
t=1
r=$PWD
#
while getopts t:o:r: options; do
	case $options in 
		t) t=$OPTARG;;
		o) o=$OPTARG;;
		r) r=$OPTARG;;
	esac
done
#
#
nohup bcl2fastq -r 1 -p $t -w 1 --runfolder-dir $r -o $o/temp_I2 --use-bases-mask Y1N*,N*,I*,N* --create-fastq-for-index-reads
#
python UMIbarcode_python2.py temp_I2/*I2*.gz > UMIs.txt
rm -r temp_I2