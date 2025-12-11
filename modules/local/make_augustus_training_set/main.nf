process MAKE_AUGUSTUS_TRAINING_SET {
    label 'make_augustus_training_set'
    input:
        tuple val(meta), path(mikado_gff)
        tuple val(meta), path(mikado_metrics)
    output:
        tuple val('augustus_training_set'), path("Augustus_training.gff"), emit: training_set
        path "versions.yml", emit: versions
    script:
        """
        python mikado_to_training_set.py ${mikado_metrics} ${mikado_gff}
        
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            python: \$(diamond --version)
        END_VERSIONS
    
        """
    stub:
        """
        touch Augustus_training.gff
        touch versions.yml
        """
}