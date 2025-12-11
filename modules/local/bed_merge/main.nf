process BED_MERGE {
    label "bed_merge"
    
    input:
        tuple val(meta), path (bed)
    
    output:
        tuple val(meta), path("${bed.name.replace('.bed', '.merged.bed')}"), emit: merged_bed
        path "versions.yml", emit: versions

    script:
        """
        bedtools merge -i ${bed} > ${bed.name.replace('.bed', '.merged.bed')}
    
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            bedtools: \$(bedtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${bed.name.replace('.bed', '.merged.bed')}
        touch versions.yml
        """    
}
