#!/bin/bash
# This script makes a swarm file for downloading the fastq files for all the runs in a BioProject
# Written by Matthew J. Brooks on Feb 12th, 2020
# This script is made for running on Biowulf using SLURM.

module load sratoolkit edirect

#----------------#
# Edit for BioProject ID and location for fastq files
gse=<GEO_accession>
wd=/path/to/wd/$gse
ENTREZ_KEY=<Eutils_API_key>

#----------------#
# Get the BioProject ID from the GEO ID
mapfile -t prj < <( \
esearch -db gds -query $gse | \
efetch -format runinfo | \
grep 'PRJN' | \
cut -d '=' -f 2)

#----------------#
# Get the SRR for all the samples in the BioProject
mapfile -t srr < <( \
esearch -db sra -query $prj | \
efetch -format runinfo | \
cut -d ',' -f 1 | \
grep SRR)

#----------------#
# This generates the swarm script

# Make the directory for the project
mkdir -p $wd/FQ

# submit script for swarm file
echo '#swarm -f dwnld_fq.swarm --module sratoolkit --gres=lscratch:500 -g 12 -t 6 --time 04:00:00 --logdir logs' > $wd/dwnld_fq.swarm

# swarm script for each SRR file
for samp in "${srr[@]}"
do
echo "fasterq-dump -O /lscratch/\$SLURM_JOBID --split-files $samp; \
cd /lscratch/\$SLURM_JOBID/; \
for i in \`ls *fastq\`; do gzip \$i; done; \
for j in \`ls *gz\`; do cp \$j $wd/FQ; done;" >> $wd/dwnld_fq.swarm
done
