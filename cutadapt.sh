#!/bin/bash
#SBATCH --job-name=cutadapt
#SBATCH --cpus-per-task=8
#SBATCH --mem=12G
#SBATCH --gres=lscratch:200
#SBATCH --time=04:00:00

set -euo pipefail

module load cutadapt/5.0

# Input and output directories
INPUT_DIR="R9_raw_R2"
OUTPUT_DIR="R9_trimmed_R2"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop over FASTQ files
for fq in "$INPUT_DIR"/*.fastq.gz; do
    # Handle case where no files match
    [[ -e "$fq" ]] || { echo "No FASTQ files found in $INPUT_DIR"; exit 1; }

    fname=$(basename "$fq")

    echo "Trimming 3 bases from: $fname"

    cutadapt \
        -u 3 \
        -j 6 \
        -o "$OUTPUT_DIR/$fname" \
        "$fq"

done

echo "All files trimmed successfully."
