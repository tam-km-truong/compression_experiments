mkdir -p ./atb/01_source_files/tar_xz/
tail -n +2 file_list.all.latest.tsv | cut -f6 | uniq | xargs -I {} -n 1 curl --output-dir ./atb/01_source_files/tar_xz/ -LJO "{}"