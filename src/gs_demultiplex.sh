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
mkdir "$ou"/index_reads
mv "$ou"/*_I*.fastq.gz "$ou"/index_reads
mkdir "$ou"/Undetermined_reads
mv "$ou"/Undetermined*.fastq.gz "$ou"/Undetermined_reads
echo "to troubleshoot failed demultiplexing, try 'tail nohup.out'"
