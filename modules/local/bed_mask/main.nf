process BED_MASK {
    label "bed_mask"
    
    input:
        path genome
        tuple val(meta), path (rep_bed)
    
    output:
        path "genome.sm.fasta", emit: masked_genome
        path "versions.yml", emit: versions

    script:
        """
        bedtools maskfasta -soft -fi ${genome} -bed ${rep_bed} -fo genome.sm.fasta
    
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            bedtools: \$(bedtools --version)
        END_VERSIONS
        """
    stub:
        """
        touch genome.sm.fasta
        touch versions.yml
        """    
}
