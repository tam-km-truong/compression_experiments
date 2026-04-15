mkdir -p ./atb/04_compression_results/AGC/
for f in ./atb/03_ordering_and_batching/03_batches/reordered/*; 
    do mbgc c -m 3 -t 25 $f .atb/04_compression_results/MBGC/$(basename $f .txt).mbgc;
done