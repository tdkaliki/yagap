scoringfile=mammalian.yaml
protdb=/data/SBCS-ademendoza/02-lukesarre/db/Uniprot_SwissProt_020221

mikado configure -t $NSLOTS --list mikado_list.txt  --reference ../../Genome.fasta --mode permissive --scoring $scoringfile --copy-scoring scoring_copy.yaml --junctions ../Portcullis/junctions.bed -bt $protdb mikado_configuration.yaml

mikado prepare --json-conf mikado_configuration.yaml
