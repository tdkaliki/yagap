process REPEATMASKER_WITH_MODEL {
    label "repeatmasker"
    
    input:
        tuple val(model_id), path(model), path(genome)
    
    output:
        tuple val(model_id), path ("*.gff"), emit: repeat_gff
        path "versions.yml", emit: versions
    
    script:
        """
        RepeatMasker -nolow -norna -pa 3 -gff -xsmall -lib ${model} ${genome}
    
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            RepeatMasker: \$(RepeatMasker --version)
        END_VERSIONS
        """
    stub:
        """
        touch test.gff
        touch versions.yml
        """
}

process REPEATMASKER_STANDARD {
    label "repeatmasker"
    
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
            RepeatMasker: \$(RepeatMasker --version)
        END_VERSIONS
        """
    stub:
        """
        touch test.gff
        touch versions.yml
        """
}
