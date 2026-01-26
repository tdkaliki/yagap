process MIKADO_CONFIGURE {
    label 'mikado_configure'
    input:
        tuple val(meta), path(mikado_list)
        path genome
        val scoringfile
        path protdb
        tuple val(meta), path(junctions)
    output:
        tuple val('mikado_configuration'), path("mikado_configuration.yaml"), emit: mikado_configuration
        tuple val('mikado_configuration'), path("scoring_copy.yaml"), emit: mikado_scoring_copy
        path "versions.yml", emit: versions
    script:
        """
        mikado configure -t ${task.cpus} --list ${mikado_list}  --reference ${genome} --mode permissive --scoring ${scoringfile} --copy-scoring scoring_copy.yaml --junctions ${junctions} -bt ${protdb} mikado_configuration.yaml
        
        #mikado prepare --json-conf mikado_configuration.yaml
        #cat <<-END_VERSIONS > versions.yml
        #"${task.process}":
        #    mikado: \$(mikado --version)
        #END_VERSIONS
        
        touch versions.yml

        """
    stub:
        """
        touch mikado_configuration.yaml
        touch scoring_copy.yaml
        touch versions.yml
        """
}

process MIKADO_PREPARE {
    label 'mikado_prepare'
    input:
        tuple val(meta), path(mikado_list)
        tuple val(meta), path(mikado_configuration)
        tuple val(meta), path(mikado_scoring_copy)
        path genome
        path protdb
        tuple val(meta), path(junctions)    
    output:
        tuple val('mikado_prepare'), path("mikado_prepared.fasta"), emit: mikado_prepared
	tuple val('mikado_prepare'), path("mikado_prepared.gtf"), emit: mikado_prepared_gtf
        path "versions.yml", emit: versions
    script:
        """
        mikado prepare --json-conf ${mikado_configuration}
        
        #cat <<-END_VERSIONS > versions.yml
        #"${task.process}":
        #    mikado: \$(mikado --version)
        #END_VERSIONS
        touch versions.yml
        """
    stub:
        """
        touch mikado_prepared.fasta
        touch versions.yml
        """
}

process MIKADO_SERIALISE {
    label 'mikado_serialise'
    input:
        tuple val(meta), path(mikado_list)
        path genome
        tuple val(meta), path(mikado_scoring_copy)
        tuple val(meta), path(mikado_configuration)
        tuple val(meta), path(diamond_res)
        tuple val(meta), path(transdecoder_res)
        path protdbfas
        tuple val(meta), path(mikado_prepared)
        tuple val(meta), path(junctions)
    output:
        tuple val('mikado_serialise'), path("mikado.db"), emit: mikado_serialise_res
        path "versions.yml", emit: versions
    script:
        """
        mikado serialise --procs ${task.cpus} --json-conf ${mikado_configuration} --tsv ${diamond_res} --orfs ${transdecoder_res} --blast_targets ${protdbfas} --transcripts ${mikado_prepared} --junctions ${junctions}
        
        #cat <<-END_VERSIONS > versions.yml
        #"${task.process}":
        #    mikado: \$(diamond --version)
        #END_VERSIONS
        
        touch versions.yml
        """
    stub:
        """
        touch mikado.db
        touch versions.yml
        """
}

process MIKADO_PICK {
    label 'mikdo_pick'
    input:
        tuple val(meta), path(mikado_list)
        path genome
        path protdb
        tuple val(meta), path(junctions)
        tuple val(meta), path(mikado_configuration)
        tuple val(meta), path(mikado_serialise_res)
        tuple val(meta), path(mikado_scoring_copy)
        tuple val(meta), path(mikado_prepared)
	tuple val(meta), path(mikado_prepared_gtf)
    output:
        tuple val('mikado_loci_gff'), path("mikado.loci.gff3"), emit: mikado_gff
        tuple val('mikado_loci_metrics'), path("mikado.loci.metrics.tsv"), emit: mikado_metrics
        path "versions.yml", emit: versions
    script:
    """
        mikado pick --procs ${task.cpus} --json-conf ${mikado_configuration} --subloci-out mikado.subloci.gff3

        #cat <<-END_VERSIONS > versions.yml
        #"${task.process}":
        #    mikado: \$(diamond --version)
        #END_VERSIONS

        touch versions.yml
    """
    stub:
        """
        touch mikado.loci.gff3
        touch mikado.loci.metrics.tsv
        touch versions.yml
        """
}
