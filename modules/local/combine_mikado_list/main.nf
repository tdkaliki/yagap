process COMBINE_MIKADO_LIST{
    label 'combine_mikado_lists'
    
    input:
        tuple val(meta_info), path (lists)
    output:
        tuple val(new_meta_info), path ("mikado_list.txt") ,emit:mikado_list
    script:
        new_meta_info = "mikado_list"
        """
        cat *.txt > mikado_list.txt
        """
    stub:
        """
        touch mikado_list.txt
        """    
}
