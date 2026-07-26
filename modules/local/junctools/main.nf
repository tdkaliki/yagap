process JUNCTOOLS{
    label 'junctools'
    container 'https://depot.galaxyproject.org/singularity/portcullis%3A1.2.4--py312hdf7dc61_5'
    input:
        tuple val(meta_info), path(junctions_bed)
    output:
        tuple val("intron_hints_gff"), path("intron_hints.gff"),emit:intron_hints
        path "versions.yml", emit: versions
    script:
        """
        junctools convert -if bed -of igff -o intron_hints.gff ${junctions_bed}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            junctools: \$(junctools --version)
        END_VERSIONS
        
	"""
    stub:
        """
        touch intron_hints.gff
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            junctools: \$(junctools --version)
        END_VERSIONS
        """    
}




