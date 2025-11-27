cat Genome_sm_part_*.aug.out > Genome_sm.aug.out

grep "  AUGUSTUS        " Genome_sm.aug.out > Genome_sm_augustus.gff

gffread Genome_sm_augustus.gff -E -T -C -V -g Genome.sm.fasta -o augustus_genes.gtf

ls -d "$PWD/"augustus_genes.gtf | awk '{print $s "      augustus        True    5       True    False   False"}' > augustus_for_mikado.txt
