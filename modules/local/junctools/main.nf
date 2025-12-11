process JUNCTOOLS{
    label 'junctools'
    
    input:
        tuple val(meta_info), path(junctions_bed)
    output:
        tuple val(new_meta_info), path("intron_hints.gff"),emit:intron_hints
        path "versions.yml", emit: versions
    script:
        new_meta_info = "intron_hints_gff"
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
        touch versions.yml
        """    
}




