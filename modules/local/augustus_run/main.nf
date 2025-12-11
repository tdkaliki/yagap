process AUGUSTUS_RUN {
    label 'augustus_run'
    input:
        tuple val(meta), path(augustus_hints)
        val specname
        tuple val(genome_id), path(genome)

    output:
        tuple val(genome_id), path("${genome_id}.aug.out"), emit:augustus_out
        path "versions.yml", emit: versions
    script:
        """
        augustus --uniqueGeneId=true --species=${specname} --hintsfile=${augustus_hints} --extrinsicCfgFile=my_extrinsic.cfg --exonnames=on --codingseq=on --allow_hinted_splicesites=gcag,atac --alternatives-from-evidence=false --softmasking=true --gff3=on ${genome} > ${genome_id}.aug.out

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            augustus: \$(diamond --version)
        END_VERSIONS
        """
    stub:
        """
        touch ${genome_id}.aug.out
        touch versions.yml
        """    
}

