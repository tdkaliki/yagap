process FILTER_METAEUK{
    label 'filter_metaeuk'
    
    input:
        path gff
    output:
        tuple val("protein_hints"), path("protein_hints.gff"),emit:intron_hints
        path "versions.yml", emit: versions
    script:
        """
        filter_metaeuk_results.py ${gff}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            python: \$(python3 --version | sed 's/^Python //')
        END_VERSIONS
        """
    stub:
        """
        touch protein_hints.gff
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            python: \$(python3 --version | sed 's/^Python //')
        END_VERSIONS
        """    
}
