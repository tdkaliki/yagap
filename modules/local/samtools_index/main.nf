process SAMTOOLS_INDEX{
    label 'samtools_index'
    container 'https://depot.galaxyproject.org/singularity/samtools%3A1.24--h9dcdb79_1'
    input:
        tuple val(sample_id), path(bam_file)
    output:
        tuple val(sample_id), path(bam_file), path("${bam_file}.bai"), emit:bam_bai
        path "versions.yml", emit: versions
    script:
        """
        samtools index ${bam_file}
        
        #rm ${bam_file}
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
        END_VERSIONS
        """
    stub:
        """
        touch ${bam_file}.bai
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
        END_VERSIONS
        """
}
