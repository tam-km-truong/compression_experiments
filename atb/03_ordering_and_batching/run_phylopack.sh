#!/bin/bash

CLUSTERS_DIR="./atb/02_extracting_and_clustering/clusters"
OUT_DIR="./atb/03_ordering_and_batching/skeleton_phylogenies"

for cluster_file in "$CLUSTERS_DIR"/*.txt; do
    [ -e "$cluster_file" ] || continue

    line_count=$(wc -l < "$cluster_file")

    if [ "$line_count" -gt 10000 ]; then
        cut_point=0.05
    else
        cut_point=0.999
    fi

    base_name=$(basename "$cluster_file" .txt)

    mkdir -p "$OUT_DIR/$base_name"

    phylopack preorder "$cluster_file" \
        --cut-point "$cut_point" \
        -o "$OUT_DIR/$base_name/${base_name}_preordered.txt" \
        -v --statistic --debug
done