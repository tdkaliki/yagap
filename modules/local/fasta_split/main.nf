module load exonerate/2.4.0
fastasplit -f Genome.fasta -o ./ -c 30
ls -1 Genome.fasta_chunk_00* > GENOME_CHUNKS.txt
i="1"
while [ $i -lt 31 ]
do
file=$(head -n $i GENOME_CHUNKS.txt | tail -n 1)
mv $file Genome.fasta_part_"$i"&
i=$[$i+1]
done
