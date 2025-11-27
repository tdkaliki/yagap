module load exonerate/2.4.0
fastasplit -f Genome.sm.fasta -o ./ -c 20
ls -1 Genome.sm.fasta_chunk_00* > GENOME_CHUNKS.txt
i="1"
while [ $i -lt 21 ]
do
file=$(head -n $i GENOME_CHUNKS.txt | tail -n 1)
mv $file Genome.sm.fasta_part_"$i"&
i=$[$i+1]
done
