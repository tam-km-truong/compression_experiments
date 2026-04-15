mkdir -p ./atb/04_compression_results/AGC/
for f in ./atb/03_ordering_and_batching/03_batches/reordered/*; 
    do ref=$(head -n 1 $f);
    agc create -a -b 500 -s 1500 -t 25 -v 2 -o ./atb/04_compression_results/AGC/$(basename $f .txt).agc -i $f $ref;
done