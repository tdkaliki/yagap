cat masking1.bed masking2.bed masking3.bed ltr.bed > all_maskingf.bed
bedtools sort -i all_maskingf.bed > all_maskingf.sorted.bed
bedtools merge -i all_maskingf.sorted.bed > all_maskingf.merged.bed
bedtools maskfasta -soft -fi Genome.fasta -bed all_maskingf.merged.bed -fo Genome.fasta.masked
