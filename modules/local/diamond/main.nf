process DIAMOND {
    label 'diamond'
    container 'community.wave.seqera.io/library/diamond:7f1d204ea308ec99'
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

process DIAMOND_MAKEDB {
    tag "${db_name}"
    label 'diamond_db'
    label 'process_medium'
    container 'community.wave.seqera.io/library/diamond:7f1d204ea308ec99'
        
    input:
    tuple val(db_name), path(protein_fasta)
    
    output:
    path("${db_name}.dmnd"), emit: db
    path "versions.yml", emit: versions
    
    script:
    """    
    diamond makedb \\
        --in ${protein_fasta} \\
        --db ${db_name} \\
        --threads ${task.cpus} 
    
        #cat <<-END_VERSIONS > versions.yml
        #"${task.process}":
        #    diamond: \$(diamond --version)
        #END_VERSIONS

        touch versions.yml
    
        """
    stub:
        """
        touch ${db_name}.dmnd
        touch versions.yml
        """    
}

