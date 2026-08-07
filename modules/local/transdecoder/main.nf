process TRANSDECODER {

    label 'transdecoder'
    container 'https://depot.galaxyproject.org/singularity/transdecoder%3A5.7.1--pl5321hdfd78af_2'
    input:
        tuple val(meta), path(fasta)
    output:
        tuple val('transdecoder_res'), path("*fasta.transdecoder.bed"), emit: transdecoder_res
        path "versions.yml", emit: versions
    script:
        """
        TransDecoder.LongOrfs -t ${fasta}
        TransDecoder.Predict -t ${fasta}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            TransDecoder: \$(TransDecoder.LongOrfs --version 2>&1 | sed 's/TransDecoder.LongOrfs //')
        END_VERSIONS
        """
    stub:
        """
        touch fasta.transdecoder.bed
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            TransDecoder: \$(TransDecoder.LongOrfs --version 2>&1 | sed 's/TransDecoder.LongOrfs //')
        END_VERSIONS
        """
}
