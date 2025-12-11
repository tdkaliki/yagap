process GFF_TO_BED {
    label "gff_to_bed"
    
    input:
        tuple val(meta), path (gff)
    
    output:
        tuple val(meta), path("${meta}.rm.bed"), emit: bed
    
    script:
        """
        grep -v "#" ${gff} | cut -f 1,4,5 > ${meta}.rm.bed
        """
    stub:
        """
        touch ${meta}.rm.bed
        """    
}
