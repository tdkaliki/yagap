process DIAMOND {
    label 'diamond'
    input:
        tuple val(meta), path(fasta)
        path protdb
    output:
        tuple val('diamond_res'), path("diamond_res.tsv"), emit: diamond_res
        path "versions.yml", emit: versions
    script:
        """
        diamond blastx --query ${fasta} --max-target-seqs 5 --sensitive --index-chunks 1 --threads ${task.cpus} --db ${protdb} --evalue 1e-6 --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore ppos btop --out diamond_res.tsv

        #cat <<-END_VERSIONS > versions.yml
        #"${task.process}":
        #    diamond: \$(diamond --version)
        #END_VERSIONS

        touch versions.yml
    
        """
    stub:
        """
        touch diamond_res.tsv
        touch versions.yml
        """    
}
