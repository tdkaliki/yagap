process TRANSDECODER {
    label 'transdecoder'
    input:
        tuple val(meta), path(fasta)
    output:
        tuple val('transdecoder_res'), path("fasta.transdecoder.bed"), emit: transdecoder_res
        path "versions.yml", emit: versions
    script:
        """
        TransDecoder.LongOrfs -t ${fasta}
        TransDecoder.Predict -t ${fasta}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            TransDecoder: \$(diamond --version)
        END_VERSIONS
    
        """
    stub:
        """
        touch fasta.transdecoder.bed
        touch versions.yml
        """
}
