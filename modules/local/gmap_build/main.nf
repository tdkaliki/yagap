process GMAP_BUILD{
    label 'gmap_build'
    container 'https://depot.galaxyproject.org/singularity/gmap%3A2025.07.31--pl5321hb1d24b7_1'
    input:
        path genome
    output:
        path "gmapdb" ,emit:gmapdb
        //path "Genome" ,emit:genomedb
        path "versions.yml", emit: versions
    script:
        """
        gmap_build -D gmapdb -d Genome ${genome}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            gmap: \$(gmap --version)
        END_VERSIONS
        """
    stub:
        """
        mkdir -p gmapdb/Genome
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            gmap: \$(gmap --version)
        END_VERSIONS
        """    
}
