#!/bin/bash

SRC_DIR="./atb/01_source_files"
TAR_DIR="$SRC_DIR/tar_xz"
FILE_LIST="$SRC_DIR/file_list.all.latest.tsv"

mkdir -p "$TAR_DIR"

if [ ! -f "$FILE_LIST" ]; then
    if [ -f "${FILE_LIST}.gz" ]; then
        pigz -d -k "${FILE_LIST}.gz"
    else
        echo "Error: $FILE_LIST (and .gz) not found."
        exit 1
    fi
fi

tail -n +2 "$FILE_LIST" | cut -f6 | sort -u | xargs -I {} -P 4 sh -c 'echo "Downloading: $(basename "$1")"; curl --fail --show-error --silent --output-dir "$TAR_DIR" -LJO "$1"' _ {}