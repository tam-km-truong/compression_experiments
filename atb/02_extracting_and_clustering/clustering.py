import pandas as pd
import os

os.makedirs('./atb/02_extracting_and_clustering/clusters', exist_ok=True)

atb = pd.read_csv("./atb/01_source_files/file_list.all.latest.tsv", sep="\t")

atb['sample'] = './atb/02_extracting_and_clustering/fasta_files/' + atb['sample'].astype(str) + '.fa.gz'

species_counts = atb.groupby('tar_xz')['species_miniphy'].nunique()

dustbin = species_counts[species_counts > 1].index.astype(str).tolist()

single_species_batches = species_counts[species_counts == 1].index

atb_clusters = atb[atb['tar_xz'].isin(single_species_batches)]

clusters = atb_clusters.groupby('species_miniphy')['tar_xz'].unique()

dustbin_genomes = atb[atb['tar_xz'].isin(dustbin)]['sample'].astype(str).tolist()

with open('./atb/02_extracting_and_clustering/clusters/dustbin.txt', 'w') as f:
    if dustbin_genomes:
        f.write('\n'.join(dustbin_genomes) + '\n')

clusters = atb_clusters.groupby('species_miniphy')['sample'].unique()

for species, genomes in clusters.items():
    filename = f'./atb/02_extracting_and_clustering/clusters/{species}.txt'
    with open(filename, 'w') as f:
        f.write('\n'.join(genomes.astype(str)) + '\n')