#!/bin/bash
# Author: Margaret R. Starostik
# Last update: 20170401 by Matthew Brooks
# Run with: sbatch --time=4:00:00 submit.sh

cd $SLURM_SUBMIT_DIR
module load python/3.5
module load snakemake/4.5.1

mkdir -p logs
snakemake \
--snakefile Indexes.py \
--jobname "{rulename}.{jobid}.snake" \
--verbose -j \
--keep-going \
--stats "Indexes_snakefile_{jobid}.stats" \
--latency-wait 180 \
--timestamp \
--rerun-incomplete \
--cores 300 \
--cluster="sbatch --mem={params.mem} --time={params.time} --cpus-per-task={threads} --out logs/job_%j.out" >& "Indexes_$SLURM_JOB_ID.snakefile.log"
