process MINIMAP2_LR_MAPPING{
    label 'minimap2_lr_mapping'
    
    input:
        tuple val(sample_id), path(lr_file)
        pasth genome
    output:
        tuple val(sample_id), path("${sample_id}.minimap2.sorted.bam"), path("${sample_id}.minimap2.sorted.bam.bai"), emit:minimap2_bam
        path "versions.yml", emit: versions
    script:
        """
        minimap2 -t ${task.cpus} -ax splice -uf -k14 ${genome} ${lr_file} | samtools view -Sb - > ${sample_id}.minimap2.bam
        samtools sort ${task.cpus} -o ${sample_id}.minimap2.sorted.bam ${sample_id}.minimap2.bam
        samtools index ${sample_id}.minimap2.sorted.bam
        ${sample_id}.minimap2.bam

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(hisat2 --version)
            samtools: \$(samtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.minimap2.sorted.bam
        touch ${sample_id}.minimap2.sorted.bam.bai
        touch versions.yml
        """
}

process MINIMAP2_LR{
    label 'minimap2_lr'
    
    input:
        tuple val(sample_id), path(lr_file)
        pasth genome
    output:
        tuple val(sample_id), path("${sample_id}.hisat2.sam"), emit:hisat2_sam
        path "versions.yml", emit: versions
    script:
        """
        minimap2 -t ${task.cpus} -ax splice -uf -k14 ${genome} ${lr_file} > ${sample_id}.minimap2.sam
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(hisat2 --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.hisat2.sam
        touch versions.yml
        """
}

process MINIMAP2_CDNA_MAPPING{
    label 'minimap2_cdna_mapping'
    
    input:
        tuple val(sample_id), path(lr_file)
        pasth genome
    output:
        tuple val(sample_id), path("${sample_id}.minimap2.sorted.bam"), path("${sample_id}.minimap2.sorted.bam.bai"), emit:minimap2_bam
        path "versions.yml", emit: versions
    script:
        """
        minimap2 -t ${task.cpus} -ax splice ${genome} ${lr_file} | samtools view -Sb - > ${sample_id}.minimap2.bam
        samtools sort ${task.cpus} -o ${sample_id}.minimap2.sorted.bam ${sample_id}.minimap2.bam
        samtools index ${sample_id}.minimap2.sorted.bam
        ${sample_id}.minimap2.bam

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(hisat2 --version)
            samtools: \$(samtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.minimap2.sorted.bam
        touch ${sample_id}.minimap2.sorted.bam.bai
        touch versions.yml
        """
}

process MINIMAP2_CDNA{
    label 'minimap2_cdna'
    
    input:
        tuple val(sample_id), path(lr_file)
        pasth genome
    output:
        tuple val(sample_id), path("${sample_id}.hisat2.sam"), emit:hisat2_sam
        path "versions.yml", emit: versions
    script:
        """
        minimap2 -t ${task.cpus} -ax splice ${genome} ${lr_file} > ${sample_id}.minimap2.sam
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(hisat2 --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.hisat2.sam
        touch versions.yml
        """
}
