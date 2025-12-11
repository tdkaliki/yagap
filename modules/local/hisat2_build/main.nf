process HISAT2_BUILD{
    label 'hisat2_build'
    
    input:
        path genome
    output:
        path "${genome.baseName}.hisat2_index" ,emit:hisat2_index
        path "versions.yml", emit: versions
    script:
        new_meta_info = "hisat2_index"
        """
        hisat2-build ${genome} ${genome.baseName}.hisat2_index

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            hisat2: \$(hisat2 --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${genome.baseName}.hisat2_index
        touch versions.yml
        """    
}
