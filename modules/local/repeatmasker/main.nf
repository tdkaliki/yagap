process REPEATMASKER_WITH_MODEL {
    label "repeatmasker"
    container 'https://depot.galaxyproject.org/singularity/repeatmasker%3A4.2.4--pl5321hdfd78af_0'
    input:
        tuple val(model_id), path(model), path(genome)
    
    output:
        tuple val(model_id), path ("*.gff"), emit: repeat_gff
        path "versions.yml", emit: versions
    
    script:
        """
        #RepeatMasker -nolow -norna -pa 3 -gff -xsmall -lib ${model} ${genome}
        RepeatMasker -famdb_dir '' -nolow -norna -pa 3 -gff -xsmall -lib ${model} ${genome}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            RepeatMasker: \$(RepeatMasker --version | head -n1 | sed 's/^.*version //')
        END_VERSIONS
        """
    stub:
        """
        touch ${genome}.gff
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            RepeatMasker: \$(RepeatMasker --version | head -n1 | sed 's/^.*version //')
        END_VERSIONS
        """
}

process REPEATMASKER_STANDARD {
    label "repeatmasker"
    container 'https://depot.galaxyproject.org/singularity/repeatmasker%3A4.2.4--pl5321hdfd78af_0'
    input:
        tuple val(species), path(genome)
    
    output:
        tuple val(species), path ("*.gff"), emit: repeat_gff
        path "versions.yml", emit: versions
    
    script:
        """
        RepeatMasker -species ${species} -gff -xsmall -nolow -norna -lcambig -s -a -pa 3 ${genome}
    
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            RepeatMasker: \$(RepeatMasker --version | head -n1 | sed 's/^.*version //')
        END_VERSIONS
        """
    stub:
        """
        touch ${genome}.gff
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            RepeatMasker: \$(RepeatMasker --version | head -n1 | sed 's/^.*version //')
        END_VERSIONS
        """
}
