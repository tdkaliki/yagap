process COMBINE_GFFS {
    label "combine_gffs"
    
    input:
        tuple val(model_id), path (genome)
    
    output:
        tuple val(model_id), path("${model_id}.rm.gff"), emit: gff
    
    script:
        """
        cat *.gff > ${model_id}.rm.gff
        """
    stub:
        """
        touch ${model_id}.rm.gff
        """    
}
