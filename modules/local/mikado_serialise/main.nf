blasttargets=/data/SBCS-ademendoza/02-lukesarre/db/Uniprot_SwissProt_020221.fasta

mikado serialise --procs 10 --json-conf mikado_configuration.yaml --tsv mikado.diamond.tsv --orfs mikado_prepared.fasta.transdecoder.bed --blast_targets $blasttargets --transcripts mikado_prepared.fasta --junctions ../Portcullis/junctions.bed
