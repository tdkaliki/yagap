process GMAP_BUILD{
    label 'gmap_build'
    
    input:
        path genome
    output:
        path "gmapdb" ,emit:gmapdb
        path "Genome" ,emit:genomedb
        path "versions.yml", emit: versions
    script:
        new_meta_info = "hisat2_index"
        """
        gmap_build -D gmapdb -d Genome ${genome}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            gmap: \$(gmap --version)
        END_VERSIONS
        """
    stub:
        """
        mkdir gmapdb
        mkdir Genome
        touch versions.yml
        """    
}
