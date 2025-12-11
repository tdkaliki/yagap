process BED_SORT {
    label "bed_sort"
    
    input:
        tuple val(meta), path (bed)
    
    output:
        tuple val(meta), path("${bed.name.replace('.bed', '.sorted.bed')}"), emit: sorted_bed
        path "versions.yml", emit: versions
    
    script:
        """
        bedtools sort -i ${bed} > ${bed.name.replace('.bed', '.sorted.bed')}
    
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            bedtools: \$(bedtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${bed.name.replace('.bed', '.sorted.bed')}
        touch versions.yml
        """    
}
