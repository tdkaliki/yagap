process AUGUSTUS_RUN {
    label 'augustus_run'
    container 'https://depot.galaxyproject.org/singularity/augustus%3A3.5.0--pl5321h9716f88_9'
    input:
        tuple val(meta), path(augustus_hints)
        tuple val(specname), path (augustus_config)
        tuple val(genome_id), path(genome)
        path extrinsic_cfg
    output:
        tuple val(genome_id), path("${genome_id}.aug.out"), emit:augustus_out
        path "versions.yml", emit: versions
    script:
        """
        export AUGUSTUS_CONFIG_PATH=${augustus_config}
        augustus --uniqueGeneId=true --species=${specname} --hintsfile=${augustus_hints} --extrinsicCfgFile=${extrinsic_cfg} --exonnames=on --codingseq=on --allow_hinted_splicesites=gcag,atac --alternatives-from-evidence=false --softmasking=true --gff3=on ${genome} > ${genome_id}.aug.out

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            augustus: \$(augustus --version 2>&1 | head -n1 | grep -oP '\\d+\\.\\d+\\.\\d+')
        END_VERSIONS
        """
    stub:
        """
        touch ${genome_id}.aug.out
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            augustus: \$(augustus --version 2>&1 | head -n1 | grep -oP '\\d+\\.\\d+\\.\\d+')
        END_VERSIONS
        """    
}

