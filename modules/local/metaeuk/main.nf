mkdir Genome_DB
metaeuk createdb ../Genome.fasta ./Genome_DB/Genome.DB
mkdir workdir
cd workdir
metaeuk easy-predict ../Genome_DB/Genome.DB ../Ref_Prot_DB/Ref_Prot_ProfileDb metaeuk_res tmp/ --threads $NSLOTS --max-intron 425000
