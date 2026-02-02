process JUNCTOOLS{
    label 'junctools'
    container 'community.wave.seqera.io/library/portcullis:7eb0b668b6eb7926'
    input:
        tuple val(meta_info), path(junctions_bed)
    output:
        tuple val("intron_hints_gff"), path("intron_hints.gff"),emit:intron_hints
        path "versions.yml", emit: versions
    script:
        """
        junctools convert -if bed -of igff -o intron_hints.gff ${junctions_bed}

        #cat <<-END_VERSIONS > versions.yml
        #"${task.process}":
        #    junctools: \$(junctools --version)
        #END_VERSIONS
        
	touch versions.yml

	"""
    stub:
        """
        touch intron_hints.gff
        touch versions.yml
        """    
}




