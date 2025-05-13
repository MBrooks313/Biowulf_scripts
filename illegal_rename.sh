#!/bin/bash

# Usage check
if [[ -z "$1" ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dir="$1"

# Directory validation
if [[ ! -d "$dir" ]]; then
    echo "Error: '$dir' is not a valid directory."
    exit 1
fi

# Log file
timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
logfile="sanitize_log_$timestamp.txt"
touch "$logfile"

# Allowed character set: letters, numbers, dash, underscore, dot
# All other characters will be removed from file/directory names
find "$dir" -depth | while IFS= read -r path; do
    dirpath=$(dirname "$path")
    filename=$(basename "$path")

    # Sanitize: remove all characters not in the safe set
    sanitized=$(echo "$filename" | sed 's/[^a-zA-Z0-9._-]//g')

    # Only rename if filename changed
    if [[ "$filename" != "$sanitized" && -n "$sanitized" ]]; then
        newpath="$dirpath/$sanitized"

        # Prevent overwriting existing files
        if [[ -e "$newpath" ]]; then
            echo "Skipped (target exists): $path" | tee -a "$logfile"
        else
            mv "$path" "$newpath"
            echo "Renamed: $path -> $newpath" | tee -a "$logfile"
        fi
    fi
done

echo "Sanitization complete. Log saved to: $logfile"

