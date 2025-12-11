process FILTER_METAEUK{
    label 'filter_metaeuk'
    
    input:
        path gff
    output:
        tuple val("protei_hints"), path("protei_hints.gff"),emit:intron_hints
        path "versions.yml", emit: versions
    script:
        """
        python filter_metaeuk_results.py ${gff}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            python: \$(metaeuk --version)
        END_VERSIONS
        """
    stub:
        """
        touch protei_hints.gff
        touch versions.yml
        """    
}
