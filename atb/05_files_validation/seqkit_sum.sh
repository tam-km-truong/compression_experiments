#!/bin/bash

RES_DIR="atb/04_compression_results"
VAL_DIR="atb/05_files_validation/hashfiles"
CTRL_DIR="atb/03_ordering_and_batching/03_batches/reordered"

mkdir -p "$VAL_DIR"

for file in "$RES_DIR"/AGC/*.agc; do
    base_name=$(basename "$file" .agc)
    
    agc getcol "$file" | seqkit sum > "$VAL_DIR/${base_name}_agc_sum.txt"
done

for file in "$RES_DIR"/MBGC/*.mbgc; do
    base_name=$(basename "$file" .mbgc)
    
    mbgc d "$file" - | seqkit sum > "$VAL_DIR/${base_name}_mbgc_sum.txt"
done

for file in "$RES_DIR"/XZ/*.tar.xz; do
    base_name=$(basename "$file" .tar.xz)
    tar -xOzf "$file" | seqkit sum > "$VAL_DIR/${base_name}_xz_sum.txt"
done

for fof in "$CTRL_DIR"/*.txt; do
    base_name=$(basename "$fof" .fof)
    
    while IFS= read -r gz_file; do
        [ -n "$gz_file" ] && gzip -dc "$gz_file"
    done < "$fof" | seqkit sum > "$VAL_DIR/${base_name}_control_sum.txt"
done