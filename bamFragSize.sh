#!/bin/bash
#SBATCH --cpus-per-task=12
#SBATCH --mem=24g
#SBATCH -o bamFrag.out
#SBATCH -e bamFrag.err

module load deeptools

blklist=/data/brooksma/Index/Blacklists/v3/hg38-blacklist.v3.bed

dir_bam=/data/brooksma/NRL_L75Pfs/CutTag/bamPEFragSize/bam

b1=$dir_bam/NRL-L75Pfs-AAV_CRX_R1.target.markdup.sorted.bam
b2=$dir_bam/NRL-L75Pfs-AAV_CRX_R2.target.markdup.sorted.bam
b3=$dir_bam/NRL-L75Pfs-AAV_NRL_R1.target.markdup.sorted.bam
b4=$dir_bam/NRL-L75Pfs-AAV_NRL_R2.target.markdup.sorted.bam
b5=$dir_bam/NRL-L75Pfs_CRX_R1.target.markdup.sorted.bam
b6=$dir_bam/NRL-L75Pfs_CRX_R2.target.markdup.sorted.bam
b7=$dir_bam/NRL-L75Pfs_NRL_R1.target.markdup.sorted.bam
b8=$dir_bam/NRL-L75Pfs_NRL_R2.target.markdup.sorted.bam

bamPEFragmentSize \
-b $b1 $b2 $b3 $b4 $b5 $b6 $b7 $b8 \
-p 12 \
--samplesLabel AAV_CRX_R1 AAV_CRX_R2 AAV_NRL_R1 AAV_NRL_R2 CRX_R1 CRX_R2 NRL_R1 NRL_R2 \
--histogram fragmentSize.pdf \
--plotFileFormat pdf \
--plotTitle "Fragment size of PE CRX-NRL CUT&Run data" \
--maxFragmentLength 1000 \
--table fragmentSize.tsv \
--outRawFragmentLengths rawFragmentSize.tsv \
--blackListFileName $blklist

