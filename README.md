# GS-Preprocess
## Usage and Prerequisites
***Intended for use on computing clusters with ≥50G of RAM allocated to the GS-Preprocess pipeline***

Illumina output folder: Download from BaseSpace or directly from any Illumina sequencer after run completion. 

Illumina-format SampleSheet: https://help.basespace.illumina.com/articles/descriptive/sample-sheet/ This sheet is in .csv format and is commonly used to demultiplex illumina .bcl files (raw sequencer output)

RunInfo.xml: Contains high-level run information,such as the number of Reads and cycles in the sequencing run. This file is standard output from any illumina sequencer and will automatically populate in any run output folder. *RunInfo.xml is found in the top-level output folder of any sequencing run*



BWA Index Download: https://support.illumina.com/sequencing/sequencing_software/igenome.html

## Dependencies
*Add the below dependencies:*

	bcl2fastq2/2.20.0
	python2
	R/3.6.0
	bwa/0.7.5a
	cutadapt/1.9
	gcc/8.1.0
	
Example:
>module add bcl2fastq2/2.20.0
## Download GS-Preprocess
	git clone https://github.com/umasstr/GS-Preprocess.git
	scp -r GS-Preprocess/ user@computing.cluster:/path/to/home/dir/
## Workflow

## Prepare the Pipeline
Move into src directory

	cd GS-Preprocess/src
Make all files executable	

	chmod +x *
## Run the Pipeline

