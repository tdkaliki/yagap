process SAMBAMBA_SORT{
    label 'sambamba_sort'
    container 'https://depot.galaxyproject.org/singularity/sambamba%3A1.0.1--he614052_4'
    input:
        tuple val(sample_id), path(bam_file)
    output:
        tuple val(sample_id), path("${sam_file.baseName}.sorted.bam"), emit:sorted_bam_file
        path "versions.yml", emit: versions
    script:
        """
        sambamba sort -t ${task.cpus} ${bam_file}
        #rm ${bam_file}
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            sambamba: \$(sambamba --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sam_file.baseName}.sorted.bam
        touch versions.yml
        """
}
