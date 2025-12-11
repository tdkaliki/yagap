process SAMTOOLS_SORT{
    label 'samtools_sort'
    
    input:
        tuple val(sample_id), path(bam_file)
    output:
        tuple val(sample_id), path(${bam_file.name.replace('.bam', '.sorted.bam')}), emit:sorted_bam
        path "versions.yml", emit: versions
    script:
        """
        samtools sort -@ ${task.cpus} -o ${bam_file.name.replace('.bam', '.sorted.bam')}
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            samtools: \$(samtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${bam_file.name.replace('.bam', '.sorted.bam')}
        touch versions.yml
        """
}