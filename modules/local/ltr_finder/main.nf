process LTR_FINDER {
    label "ltr_finder"
    
    input:
        path genome
    
    output:
        tuple val("ltr"), path( "*.gff3"), emit: gff
        path "versions.yml", emit: versions
    
    script:
        """
        LTR_FINDER_parallel -seq Genome.fasta -threads 30
    
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            LTR_FINDER_parallel: \$(LTR_FINDER_parallel --version)
        END_VERSIONS
        """
    stub:
        """
        touch LTR_FINDER.gff3
        touch versions.yml
        """
}