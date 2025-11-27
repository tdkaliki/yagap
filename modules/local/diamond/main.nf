protdb=/data/SBCS-ademendoza/02-lukesarre/db/Uniprot_SwissProt_020221.dmnd

diamond blastx --query mikado_prepared.fasta --max-target-seqs 5 --sensitive --index-chunks 1 --threads $NSLOTS --db $protdb --evalue 1e-6 --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore ppos btop --out mikado.diamond.tsv

