process SAM_TO_BAM{
    label 'sam_to_bam'
    
    input:
        tuple val(sample_id), path(sam_file)
    output:
        tuple val(sample_id), path("${sam_file.baseName}.bam"), emit:bam_file
        path "versions.yml", emit: versions
    script:
        """
        samtools view -@ ${task.cpus} -bSu ${sam_file} > ${sam_file.baseName}.bam
        #rm ${sam_file}
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            samtools: \$(samtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sam_file.baseName}.bam
        touch versions.yml
        """
}