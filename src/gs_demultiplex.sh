#!/bin/bash
#
t=1
o=fastq_output
r=$PWD
s=SampleSheet.csv
#
while getopts t:o:r:s: options; do
	case $options in 
		t) t=$OPTARG;;
		o) o=$OPTARG;;
		r) r=$OPTARG;;
		s) s=$OPTARG;;
	esac
done
#
#
nohup bcl2fastq -r 1 -p $t -w 1 --runfolder-dir $r -o $o --use-bases-mask Y*,I*,N8I8,Y* --create-fastq-for-index-reads --sample-sheet $s
#
mkdir $o/index_reads
mv $o/*_I*.fastq.gz $o/index_reads
mkdir $o/Undetermined_reads
mv $o/Undetermined*.fastq.gz $o/Undetermined_reads
echo "to troubleshoot failed demultiplexing, try 'tail nohup.out'"
