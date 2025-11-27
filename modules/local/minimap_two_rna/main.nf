rna=/data/SBCS-ademendoza/Annotations/Bluey/new_bluebottle_data/RNAseq_nanopore/GNXM22170_pass.fastq.gz
minimap2 -t $NSLOTS -ax splice -uf -k14 ../../Genome.fasta $rna | samtools view -Sb - > RNA1.bam
samtools sort -@$NSLOTS -o RNA1.sorted.bam RNA1.bam
samtools index RNA1.sorted.bam
rm RNA1.bam

rna=/data/SBCS-ademendoza/Annotations/Bluey/new_bluebottle_data/RNAseq_nanopore/GNXM22171_pass.fastq.gz
minimap2 -t $NSLOTS -ax splice -uf -k14 ../../Genome.fasta $rna | samtools view -Sb - > RNA2.bam
samtools sort -@$NSLOTS -o RNA2.sorted.bam RNA2.bam
samtools index RNA2.sorted.bam
rm RNA2.bam
