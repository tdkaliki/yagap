process BED_MERGE {
    label "bed_merge"
    container 'https://depot.galaxyproject.org/singularity/bedtools%3A2.31.1--hf5e1c6e_2'
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
            bedtools: \$(bedtools --version | sed 's/^bedtools //')
        END_VERSIONS
        """
    stub:
        """
        touch ${bed.name.replace('.bed', '.merged.bed')}
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            bedtools: \$(bedtools --version | sed 's/^bedtools //')
        END_VERSIONS
        """    
}
