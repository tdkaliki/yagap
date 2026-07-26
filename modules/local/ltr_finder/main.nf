process LTR_FINDER {
    label "ltr_finder"
    container 'https://depot.galaxyproject.org/singularity/ltr_finder_parallel%3A1.4--hdfd78af_0'
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
            LTR_FINDER_parallel: \$(LTR_FINDER_parallel --version 2>&1 | grep -m1 -i 'Version:' | sed 's/^Version: //')
        END_VERSIONS
        """
    stub:
        """
        touch LTR_FINDER.gff3
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            LTR_FINDER_parallel: \$(LTR_FINDER_parallel --version 2>&1 | grep -m1 -i 'Version:' | sed 's/^Version: //')
        END_VERSIONS
        """
}