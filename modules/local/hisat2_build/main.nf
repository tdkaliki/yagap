process HISAT2_BUILD{
    label 'hisat2_build'
    container 'https://depot.galaxyproject.org/singularity/hisat2%3A2.2.2--h503566f_0'
    input:
        path genome
    output:
        path "${genome.baseName}.hisat2_index.*" ,emit:hisat2_index
        path "versions.yml", emit: versions
    script:
        """
        hisat2-build ${genome} ${genome.baseName}.hisat2_index

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            hisat2: \$(hisat2 --version | head -n1 | sed 's/^.*version //')
        END_VERSIONS
        """
    stub:
        """
        touch ${genome.baseName}.hisat2_index.1.ht2
        touch ${genome.baseName}.hisat2_index.2.ht2
        touch ${genome.baseName}.hisat2_index.3.ht2
        touch ${genome.baseName}.hisat2_index.4.ht2
        touch ${genome.baseName}.hisat2_index.5.ht2
        touch ${genome.baseName}.hisat2_index.6.ht2
        touch ${genome.baseName}.hisat2_index.7.ht2
        touch ${genome.baseName}.hisat2_index.8.ht2
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            hisat2: \$(hisat2 --version | head -n1 | sed 's/^.*version //')
        END_VERSIONS
        """    
}
