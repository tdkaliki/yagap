process HISAT2_MAPPING{
    label 'hisat2_mapping'
    container 'oras://community.wave.seqera.io/library/hisat2_samtools:5a258fe6e30b2c20'
    input:
        tuple val(sample_id), path(read1), path(read2)
    	path genome    
	path genome_index
    output:
        tuple val(sample_id), path("${sample_id}.hisat2.sorted.bam"), path("${sample_id}.hisat2.sorted.bam.bai"), emit:hisat2_bam
        path "versions.yml", emit: versions
    script:
        """
        hisat2 --dta -N 1 -p ${task.cpus} -x ${genome.baseName}.hisat2_index -1 ${read1} -2 ${read2} -S ${sample_id}.hisat2.sam --summary-file ${sample_id}.hisat2.log

        samtools view -@ ${task.cpus} -bSu ${sample_id}.hisat2.sam > ${sample_id}.hisat2.bam
        rm ${sample_id}.hisat2.sam

        sambamba sort -t ${task.cpus} ${sample_id}.hisat2.bam
        rm ${sample_id}.hisat2.bam

        samtools index ${sample_id}.hisat2.sorted.bam

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            hisat2: \$(hisat2 --version | head -n1 | sed 's/^.*version //')
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
            sambamba: \$(sambamba --version 2>&1 | grep -m1 '^sambamba' | sed 's/^sambamba //')
        END_VERSIONS
        
	touch versions.yml
	
	"""
    stub:
        """
        touch ${sample_id}.hisat2.sorted.bam
        touch ${sample_id}.hisat2.sorted.bam.bai
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            hisat2: \$(hisat2 --version | head -n1 | sed 's/^.*version //')
            samtools: \$(samtools --version | head -n1 | sed 's/^samtools //')
            sambamba: \$(sambamba --version 2>&1 | grep -m1 '^sambamba' | sed 's/^sambamba //')
        END_VERSIONS
        """    
}

process HISAT2{
    label 'hisat2'
    container 'https://depot.galaxyproject.org/singularity/hisat2%3A2.2.2--h503566f_0'
    input:
        tuple val(sample_id), path(read1), path(read2)
        path genome_index
    output:
        tuple val(sample_id), path("${sample_id}.hisat2.sam"), emit:hisat2_sam
        path "versions.yml", emit: versions
    script:
        """
        hisat2 --dta -N 1 -p ${task.cpus} -x ./hisat2_index/Genome.hisat2_index -1 ${read1} -2 ${read2} -S ${sample_id}.hisat2.sam --summary-file ${sample_id}.hisat2.log

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            hisat2: \$(hisat2 --version | head -n1 | sed 's/^.*version //')
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.hisat2.sam
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            hisat2: \$(hisat2 --version | head -n1 | sed 's/^.*version //')
        END_VERSIONS
        """    
}
