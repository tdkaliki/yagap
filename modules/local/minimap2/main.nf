process MINIMAP2_LR_MAPPING{
    label 'minimap2_lr_mapping'
    container 'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/37/37671219cfd244eb9b33db9345d3543ffd83037419a1c57f4648aace493ec2c2/data'
    input:
        tuple val(sample_id), path(lr_file)
        path genome
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
            minimap2: \$(minimap2 --version)
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.minimap2.sorted.bam
        touch ${sample_id}.minimap2.sorted.bam.bai
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(minimap2 --version)
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
        END_VERSIONS
        """
}

process MINIMAP2_LR{
    label 'minimap2_lr'
    container 'https://depot.galaxyproject.org/singularity/minimap2%3A2.31--h118bc1c_0'
    input:
        tuple val(sample_id), path(lr_file)
        path genome
    output:
        tuple val(sample_id), path("${sample_id}.minimap2.sam"), emit:minimap2_sam
        path "versions.yml", emit: versions
    script:
        """
        minimap2 -t ${task.cpus} -ax splice -uf -k14 ${genome} ${lr_file} > ${sample_id}.minimap2.sam
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(minimap2 --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.minimap2.sam
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(minimap2 --version)
        END_VERSIONS
        """
}

process MINIMAP2_CDNA_MAPPING{
    label 'minimap2_cdna_mapping'
    container 'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/37/37671219cfd244eb9b33db9345d3543ffd83037419a1c57f4648aace493ec2c2/data'
    input:
        tuple val(sample_id), path(lr_file)
        path genome
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
            minimap2: \$(minimap2 --version)
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.minimap2.sorted.bam
        touch ${sample_id}.minimap2.sorted.bam.bai
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(minimap2 --version)
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
        END_VERSIONS
        """
}

process MINIMAP2_CDNA{
    label 'minimap2_cdna'
    container 'https://depot.galaxyproject.org/singularity/minimap2%3A2.31--h118bc1c_0'
    input:
        tuple val(sample_id), path(lr_file)
        path genome
    output:
        tuple val(sample_id), path("${sample_id}.minimap2.sam"), emit:minimap2_sam
        path "versions.yml", emit: versions
    script:
        """
        minimap2 -t ${task.cpus} -ax splice ${genome} ${lr_file} > ${sample_id}.minimap2.sam
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(minimap2 --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.minimap2.sam
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            minimap2: \$(minimap2 --version)
        END_VERSIONS
        """
}
