process SAMTOOLS_MERGE {
    label 'samtools_merge'
    container 'https://depot.galaxyproject.org/singularity/samtools%3A1.24--h9dcdb79_1'
    input:
        tuple val(meta), path(bam_files), path(bai_file)
    
    output:
        tuple val(meta), path("${meta}.merged.bam"), emit: bam
        path "versions.yml", emit: versions
    
    script:
        """
        samtools merge \\
            -@ ${task.cpus} \\
            -o ${meta}.merged.bam \\
            ${bam_files}
    
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
        END_VERSIONS
        

	"""
    stub:
        """
        touch ${meta}.merged.bam
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
        END_VERSIONS
        """
}
