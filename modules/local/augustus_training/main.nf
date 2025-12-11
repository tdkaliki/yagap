process AUGUSTUS_TRAINING {
    label 'augustus_training'
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
            augustus: \$(diamond --version)
        END_VERSIONS
    
        """
    stub:
        """
        touch versions.yml
        """    
}
