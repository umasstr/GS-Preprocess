#!/bin/bash 
echo "GUIDE-seq pre-processing for GHPCC"

if [ "$1" == "-h" ]; then
  echo "-t <number_of_threads> -o <output_directory> -r <directory_containing_RunInfo.xml> -s </path/to/SampleSheet.csv> -b </path/to/BWAIndex/genome.fa>"
  echo "gs_preprocess output: output_dir/bam_files"
  echo "Required: 50G RAM"
  echo "Illumina-format SampleSheet: https://help.basespace.illumina.com/articles/descriptive/sample-sheet/"
  echo "RunInfo.xml: Contains high-level run information,such as the number of Reads and cycles in the sequencing run. Standard output from any illumina sequencer"
  echo "BWA Index Download: https://support.illumina.com/sequencing/sequencing_software/igenome.html"
  exit 0
fi

t=1
o=fastq_output
r=$PWD
s=SampleSheet.csv
b=Homo_sapiens/UCSC/hg38/Sequence/BWAIndex/genome.fa

while getopts t:o:r:s:b: options; do
	case $options in 
		t) t=$OPTARG;;
		o) o=$OPTARG;;
		r) r=$OPTARG;;
		s) s=$OPTARG;;
		b) b=$OPTARG;;
	esac
done

./gs_demultiplex.sh -t $t -o $o -r $r -s $s

./gs_I2.sh -t $t -o $o -r $r

python ./gs_cutadapt.py $o

mv *.trim $o

python ./bwa_gs.py $o $b $t

for i in $o/*.sam; do samtools view -Sb -@ $t $i > $o/${i%.*}.bam;done


