process STRINGTIE_HISAT{
    label 'stringtie_hisat'
    
    input:
        tuple val(sample_id), path(bam_file), path(bai_file)
    output:
        tuple val(sample_id), path("${sample_id}.stringtie.gtf"), emit:stringtie_gtf
        path "versions.yml", emit: versions
    script:
        """
        stringtie ${bam_file} -o ${sample_id}.stringtie.gtf -p ${task.cpus}
        #rm ${bam_file}
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            stringtie: \$(samtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.stringtie.gtf
        touch versions.yml
        """
}

process STRINGTIE_MINIMAP{
    label 'stringtie_minimap'
    
    input:
        tuple val(sample_id), path(bam_file), path(bai_file)
    output:
        tuple val(sample_id), path("${sample_id}.stringtie.gtf"), emit:stringtie_gtf
        path "versions.yml", emit: versions
    script:
        """
        stringtie ${bam_file} -o ${sample_id}.stringtie.gtf -p ${task.cpus} -L
        #rm ${bam_file}
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            stringtie: \$(samtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.stringtie.gtf
        touch versions.yml
        """
}
