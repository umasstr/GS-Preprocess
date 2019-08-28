#!/bin/bash 
echo "GUIDE-seq pre-processing for GHPCC"

if [ "$1" == "-h" ]; then
  echo "-t <number_of_threads> -o </path/to/output_directory> -r <directory_containing_RunInfo.xml> -s </path/to/SampleSheet.csv> -b </path/to/BWAIndex/genome.fa> -g <gRNA_sequence>"
  echo "Required: 32G RAM"
  echo "Illumina-format SampleSheet: https://help.basespace.illumina.com/articles/descriptive/sample-sheet/"
  echo "RunInfo.xml: Contains high-level run information,such as the number of Reads and cycles in the sequencing run. Standard output from any illumina sequencer"
  echo "BWA Index Download: https://support.illumina.com/sequencing/sequencing_software/igenome.html"
  exit 0
fi

t=1
o=fastq_output
r=$PWD
s=SampleSheet.csv

while getopts t:o:r:s:b:g: options; do
	case $options in 
		t) t=$OPTARG;;
		o) o=$OPTARG;;
		r) r=$OPTARG;;
		s) s=$OPTARG;;
		b) b=$OPTARG;;
		g) g=$OPTARG;;
	esac
done

./gs_demultiplex.sh -t $t -o $o -r $r -s $s

./gs_I2.sh -t $t -o $o -r $r

python gs_gRNA.py gRNA $g > gRNA.fa

python UMIbarcode_python2.py $o/temp_I2/*I2*.gz > UMIs.txt
rm -rf $o/temp_I2

python ./gs_cutadapt.py $o

python ./bwa_gs.py $o $b $t

for i in *.sam; do samtools view -Sb -@ $t $i > ${i%.*}.bam;done
rm *.sam



