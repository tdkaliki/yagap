process COMBINE_MIKADO_LIST{
    label 'combine_mikado_lists'
    
    input:
        tuple val(meta_info), path (hints)
    output:
        tuple val("Augustus_hints"), path ("Augustus_hints.gff") ,emit:augustus_hints
    script:
        """
        cat *.gff > Augustus_hints.gff
        """
    stub:
        """
        touch Augustus_hints.gff
        """    
}
