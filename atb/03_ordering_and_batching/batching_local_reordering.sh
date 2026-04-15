#!/bin/bash

BASE_DIR="atb/03_ordering_and_batching"
IN_DIR="$BASE_DIR/01_skeleton_phylogenies"
BATCH_DIR="$BASE_DIR/03_batches"

BATCH_IN_DIR="$BATCH_DIR/input"
BATCH_TREE_DIR="$BATCH_DIR/trees"
BATCH_REORDER_DIR="$BATCH_DIR/reordered"
SCRIPT_DIR="$BASE_DIR/scripts"

mkdir -p "$BATCH_IN_DIR" "$BATCH_TREE_DIR" "$BATCH_REORDER_DIR"

# 1. Split preordered files
for f in "$IN_DIR"/*/*_preordered.txt; do
    [ -e "$f" ] || continue
    
    base_name=$(basename "$f" .txt)
    
    split -l 4000 -d -a 3 --additional-suffix=.txt "$f" "$BATCH_IN_DIR/${base_name}_"
done

for f in "$BATCH_IN_DIR"/*.txt; do
    [ -e "$f" ] || continue
    
    base_name=$(basename "$f" .txt)
    full_name=$(basename "$f")
    
    attotree -L "$f" -o "$BATCH_TREE_DIR/${base_name}.nw"
    
    python "$SCRIPT_DIR/postprocess_tree.py" \
        --standardize \
        --midpoint-outgroup \
        --name-internals \
        --ladderize \
        -l "$BATCH_REORDER_DIR/$full_name" \
        "$f" \
        "$BATCH_DIR/tmp/output_tree"
done