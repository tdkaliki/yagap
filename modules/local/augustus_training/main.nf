process AUGUSTUS_TRAINING {
    label 'augustus_training'
    container 'https://depot.galaxyproject.org/singularity/augustus%3A3.5.0--pl5321h9716f88_9'
    input:
        tuple val(meta), path(trainingset)
        path genome
        val specname

    output:
        val specname, emit: specname
        path "versions.yml", emit: versions
    script:
        """
        mkdir Augustus_training
        autoAugTrain.pl --trainingset=${trainingset} --genome=${genome} --species=${specname} --workingdir=Augustus_training --optrounds=2 --verbose

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            augustus: \$(augustus --version 2>&1 | head -n1 | grep -oP '\\d+\\.\\d+\\.\\d+')
        END_VERSIONS
    
        """
    stub:
        """
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            augustus: \$(augustus --version 2>&1 | head -n1 | grep -oP '\\d+\\.\\d+\\.\\d+')
        END_VERSIONS
        """    
}
