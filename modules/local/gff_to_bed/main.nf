grep -v "#" comb1.gff | cut -f 1,4,5 > masking1.bed
grep -v "#" comb2.gff | cut -f 1,4,5 > masking2.bed
grep -v "#" comb3.gff | cut -f 1,4,5 > masking3.bed
grep -v "#" Genome.fasta.finder.combine.gff3 | cut -f 1,4,5 > ltr.bed
