process SAMTOOLS_MERGE {
    label 'samtools_merge'
    container 'community.wave.seqera.io/library/samtools:3393ec69ae2c9272'
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
        #"${task.process}":
        #    samtools: \$(samtools --version)
        #END_VERSIONS
        
	touch version.yml

	"""
    stub:
        """
        touch ${meta}.merged.bam
        touch versions.yml
        """
}
