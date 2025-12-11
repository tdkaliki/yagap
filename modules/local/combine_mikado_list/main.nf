process COMBINE_MIKADO_LIST{
    label 'combine_mikado_lists'
    
    input:
        tuple val(meta_info), path (lists)
    output:
        tuple val("mikado_list"), path ("mikado_list.txt") ,emit:mikado_list
    script:
        """
        cat *.txt > mikado_list.txt
        """
    stub:
        """
        touch mikado_list.txt
        """    
}
