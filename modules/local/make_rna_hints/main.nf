process MAKE_RNA_HINTS {
    label 'make_rna_hints'
    input:
        tuple val(meta), path(mikado_gff)
    output:
        tuple val('augustus_training_set'), path("RNA_hints.gff"), emit: rna_hints
        path "versions.yml", emit: versions
    script:
        """
        python mikado_to_hints.py ${mikado_gff}
        
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            python: \$(diamond --version)
        END_VERSIONS
        """
    stub:
        """
        touch RNA_hints.gff
        touch versions.yml
        """
}
