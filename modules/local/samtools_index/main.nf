process SAMTOOLS_INDEX{
    label 'samtools_index'
    
    input:
        tuple val(sample_id), path(bam_file)
    output:
        tuple val(sample_id), path(bam_file), path("${bam_file}.bai"), emit:bam_bai
        path "versions.yml", emit: versions
    script:
        """
        samtools index ${bam_file}
        
        #rm ${bam_file}
        #cat <<-END_VERSIONS > versions.yml
        #"${task.process}":
        #    samtools: \$(samtools --version)
        #END_VERSIONS
        
        touch versions.yml

	"""
    stub:
        """
        touch ${bam_file}.bai
        touch versions.yml
        """
}
