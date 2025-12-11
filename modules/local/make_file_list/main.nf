process CREATE_HISAT_GTF_LIST {
    label 'hisat_gtf_list'
    input:
        tuple val(meta), path(gtf_files)

    output:
        tuple val(meta), path("hisat_gtf_list.txt"), emit: gtf_list
    
    script:
        """
        for file in ${gtf_files}; do
            full_path=\$(realpath "\$file")
            name=\$(basename "\$file" .stringtie.gtf)_${meta}
            echo "\$full_path\t\$name\tTrue\t0.5\tFalse\tFalse\tFalse"
        done > hisat_gtf_list.txt
        """
    stub:
        """
        touch hisat_gtf_list.txt
        """
}

process CREATE_MINIMAP_GTF_LIST {
    label 'minimap_gtf_list'
    input:
        tuple val(meta), path(gtf_files)

    output:
        tuple val(meta), path("${meta}_minimap_gtf_list.txt"), emit: gtf_list
    
    script:
        """
        for file in ${gtf_files}; do
            full_path=\$(realpath "\$file")
            name=\$(basename "\$file" .stringtie.gtf)_${meta}
            echo "\$full_path\t\$name\tTrue\t0.5\tFalse\tFalse\tFalse"
        done > ${meta}_minimap_gtf_list.txt
        """
    stub:
        """
        touch ${meta}_minimap_gtf_list.txt
        """
}

process CREATE_GMAP_GFF_LIST {
    label 'gmap_gff_list'
    input:
        tuple val(meta), path(gff_files)

    output:
        tuple val(meta), path("${meta}_gmap_gff_list.txt"), emit: gff_list
    
    script:
        """
        for file in ${gff_files}; do
            full_path=\$(realpath "\$file")
            name=\$(basename "\$file" .gff3)_${meta}
            echo "\$full_path\t\$name\tFalse\t-0.5\tFalse\tFalse\tFalse"
        done > ${meta}_gmap_gff_list.txt
        """
    stub:
        """
        touch ${meta}_gmap_gff_list.txt
        """
}