#!/usr/bin/env bash

# Usage: ./decompress_and_gzip_tarballs.sh <input_dir> <output_dir> <xargs_threads> <pigz_threads>
# Example: ./decompress_and_gzip_tarballs.sh data/atb/by_species/salmonella_enterica \
#          /scratch/ktruong/data/atb/uncompressed/salmonella_enterica 5 10

set -euo pipefail

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <input_dir> <output_dir> <xargs_threads> <pigz_threads>"
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"
XARGS_THREADS="$3"
PIGZ_THREADS="$4"

mkdir -p "$OUTPUT_DIR"

ls "$INPUT_DIR"/*.tar.xz | xargs -P "$XARGS_THREADS" -I{} bash -e -c '
    TARFILE="$1"
    OUTPUT_DIR="$2"
    PIGZ_THREADS="$3"

    echo "Processing tarball $TARFILE"

    TMPDIR=$(mktemp -d $OUTPUT_DIR/tmp.XXXXXXXXXX)

    echo "Extracting $TARFILE into $TMPDIR"
    tar -Jxf "$TARFILE" --strip-components=1 -C "$TMPDIR"

    echo "Gzipping .fa file from $TARFILE"
    pigz -f "$TMPDIR"/*.fa -p "$PIGZ_THREADS"

    echo "Moving to destination and removing tmpdir"
    mv "$TMPDIR"/*.fa.gz "$OUTPUT_DIR"/

    rm -r "$TMPDIR"
    echo "$TARFILE done"
' sh {} "$OUTPUT_DIR" "$PIGZ_THREADS"