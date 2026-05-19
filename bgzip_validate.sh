#!/bin/bash
set -euo pipefail

FQ_FILE="fastq_errors.txt"
OUT_FILE="bgzip_validate_260519.txt"
TMP_DIR="bgzip_logs"
NPROC=8

mkdir -p "$TMP_DIR"

run_one() {
    local fq="$1"

    local base
    base=$(basename "$fq")

    local log="$TMP_DIR/${base}.log"

    {
        echo "===== $fq ====="

        if bgzip -t "$fq"
        then
            echo "OK"
        else
            echo "FAILED"
        fi

        echo
    } > "$log" 2>&1
}

export -f run_one
export TMP_DIR

xargs -P "$NPROC" -I {} bash -c 'run_one "$1"' _ {} < "$FQ_FILE"

# combine logs into one tidy file
cat "$TMP_DIR"/*.log > "$OUT_FILE"
