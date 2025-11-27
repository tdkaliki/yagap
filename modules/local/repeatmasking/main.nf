RepeatMasker -nolow -norna -pa 3 -gff -xsmall -lib Bluey_wtdbg2_racon_medaka_pilon-families.fa Genome.fasta_part_${SGE_TASK_ID}

RepeatMasker -nolow -norna -pa 3 -gff -xsmall -lib consensi.fa Genome.fasta_part_${SGE_TASK_ID}

RepeatMasker -species cnidaria -gff -xsmall -nolow -norna -lcambig -s -a -pa 3 Genome.fasta_part_${SGE_TASK_ID}
