cdna=/data/SBCS-ademendoza/Annotations/Bluey/new_bluebottle_data/cDNAseq_nanopore/cDNAseq.fastq.gz
minimap2 -t $NSLOTS -ax splice ../../Genome.fasta $cdna | samtools view -Sb - > cDNA.bam
rm cDNA.sam
samtools sort -@$NSLOTS -o cDNA.sorted.bam cDNA.bam
samtools index cDNA.sorted.bam
rm cDNA.bam
