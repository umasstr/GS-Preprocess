# GS-Preprocess
## Useage and Prerequisites
Intended for use on computing clusters with ≥50G of RAM allocated to the GS-Preprocess pipeline

## Dependencies
*Add the below dependencies:*

	bcl2fastq2/2.20.0
	python2
	R/3.6.0
	bwa/0.7.5a
	cutadapt/1.9
	gcc/8.1.0
	
Example:
	module add bcl2fastq2/2.20.0
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

