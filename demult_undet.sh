#!/bin/bash

##############################################################################################
# Modified/tested by Matthew J. Brooks on Dec 5, 2024
# Obtained from https://github.com/bhattlab/bhattlab_workflows/issues/22
#
# This script pulls out reads for particular indexes and generates fastq files...essentially 
# demultiplexing the Undeterminied reads from Illumina.
#
# Requires barcodes.txt file containing two columns with desired base name and associated 
# indexes (2nd is in reverse complement) found in 1st line of read, eg.
#
# R42024-218_Female_7_Left-Ret GGCTTAAG+GGTCACGA
# R42024-219_Female_8_Left-Ret AATCCGGA+AACTGTAG
# R42024-258_18MO-F4 AGGCAGAG+GGCATTCT
# R42024-259_18MO-F5 GAATGAGA+AATGCCTC
#
#
# Run on Biowulf using command...
#
# cat barcodes.txt | xargs -l bash -c 'sbatch --mem=8g demult_undet.sh $0 $1'
##############################################################################################

module load sickle/1.33

#demultiplex samples
gzip -cd Undetermined.R1.fastq.gz | grep -A3 --no-group-separator -i $2 | gzip > ${1}_1.fq.gz &
gzip -cd Undetermined.R2.fastq.gz | grep -A3 --no-group-separator -i $2 | gzip > ${1}_2.fq.gz &
wait

#remove instances that do not have pairs (trimming will fail if you do not)
sickle pe -t sanger -g -f ${1}_1.fq.gz -r ${1}_2.fq.gz -o ${1}.R1.fastq.gz -p ${1}.R2.fastq.gz -s ${1}_single.fq
