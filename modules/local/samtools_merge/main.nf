process SAMTOOLS_MERGE {
    label 'samtools_merge'
    
    input:
        tuple val(meta), path(bam_files), path(bai_file)
    
    output:
        tuple val(meta), path("${meta.id}.merged.bam"), emit: bam
        path "versions.yml", emit: versions
    
    script:
        """
        samtools merge \\
            -@ ${task.cpus} \\
            -o ${meta.id}.merged.bam \\
            ${bam_files}
    
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            samtools: \$(samtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${meta.id}.merged.bam
        touch versions.yml
        """
}