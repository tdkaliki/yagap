process BED_MASK {
    label "bed_mask"
    container 'https://depot.galaxyproject.org/singularity/bedtools%3A2.31.1--hf5e1c6e_2'
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
            bedtools: \$(bedtools --version | sed 's/^bedtools //')
        END_VERSIONS
        """
    stub:
        """
        touch genome.sm.fasta
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            bedtools: \$(bedtools --version | sed 's/^bedtools //')
        END_VERSIONS
        """    
}
