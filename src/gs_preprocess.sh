#!/bin/bash 
echo "GUIDE-seq pre-processing for GHPCC"

if [ "$1" == "-h" ]; then
  echo "-t <number_of_threads> -o </path/to/output_directory> -r <directory_containing_RunInfo.xml> -s </path/to/SampleSheet.csv> -b </path/to/BWAIndex/genome.fa> -g <gRNA_sequence> -I <# UMI nucleotides>"
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
I=8

while getopts t:o:r:s:b:g:I: options; do
	case $options in 
		t) t=$OPTARG;;
		o) o=$OPTARG;;
		r) r=$OPTARG;;
		s) s=$OPTARG;;
		b) b=$OPTARG;;
		g) g=$OPTARG;;
		I) I=$OPTARG;;
	esac
done


bcl2fastq -r 1 -p $t -w 1 --runfolder-dir $r -o $o --use-bases-mask Y*,I*,N"$I"I8,Y* --barcode-mismatches 0 --create-fastq-for-index-reads --sample-sheet $s 

if [ $? -ne 0 ]; then echo "Error in the demultiplexing step. Exiting."; exit 1; fi


if [ "$s" == "SampleSheet.csv" ] || [ "$s" == "./SampleSheet.csv" ]; then mv "$s" "${s%.csv}_1.csv" && s="${s%.csv}_1.csv"; fi

bcl2fastq -r 1 -p $t -w 1 --runfolder-dir $r -o $o/temp_I2 --use-bases-mask Y1N*,N*,I*,N* --create-fastq-for-index-reads && \
if [ "$s" == "SampleSheet_1.csv" ] || [ "$s" == "./SampleSheet_1.csv" ]; then mv $s ${s%_1.csv}.csv; fi

if [ $? -ne 0 ]; then echo "Error in the index generation step. Exiting."; exit 1; fi

for x in $o/*_R1_*.gz
do
  cutadapt -j $t \
    -b TTGAGTTGTCATATGTTAATAACGGTAT \
    -b ACATATGACAACTCAATTAAAC \
    -b ATACCGTTATTAACATATGACAACTCAA \
    -b GTTTAATTGAGTTGTCATATGT \
    -B TTGAGTTGTCATATGTTAATAACGGTAT \
    -B ACATATGACAACTCAATTAAAC \
    -B ATACCGTTATTAACATATGACAACTCAA \
    -B GTTTAATTGAGTTGTCATATGT \
    -o ${x%_001*}.fq -p ${x%_R1*}_R2.fq \
	$x ${x%_R1*}_R2_001.fastq.gz >> cutadapt.out
done

if [ $? -ne 0 ]; then echo "Error in the trimming step. Exiting."; exit 1; fi

zcat $o/temp_I2/Undetermined_S0_L001_I2_001.fastq.gz | awk -v a="$I" 'NR % 4 == 1 {printf $1 "\t"} NR % 4 == 2 {print substr($0, 1, a)}' > UMIs.txt

if [ $? -ne 0 ]; then echo "Error in the UMI library generation step. Exiting."; exit 1; fi


for x in $o/*_R1.fq; do bwa mem -t $t $g $x ${x%_R1*}_R2.fq | samtools view -Sb -@ $t - | samtools sort -@ $t - > ${x%_R1*}.bam; done

if [ $? -ne 0 ]; then echo "Error in the alignment (BWA) step. Exiting."; exit 1; fi

echo ">gRNA" > gRNA.fa && echo "$g" >> gRNA.fa





