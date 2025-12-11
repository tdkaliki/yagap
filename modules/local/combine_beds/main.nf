process COMBINE_BEDS {
    label "combine_beds"
    
    input:
        tuple val(meta), path (bed)
    
    output:
        tuple val("all_masking"), path("all_masking.bed"), emit: bed
    
    script:
        """
        cat *.bed > all_masking.bed
        """
    stub:
        """
        touch all_masking.bed
        """    
}
