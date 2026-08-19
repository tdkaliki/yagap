process METAEUK_RUN{
    label 'metaeuk_run'
    container 'https://depot.galaxyproject.org/singularity/metaeuk%3A7.bba0d80--pl5321hd6d6fdc_2'
    input:
        path fasta
        tuple val(gb_name), path (genome_db)
        path ref_prot_db
        val max_intron
    output:
        path "metaeuk_res.gff" ,emit:metaeuk_gff
        path "versions.yml", emit: versions
    script:
        """
        metaeuk easy-predict ${gb_name} ${ref_prot_db}/Ref_Prot_ProfileDb metaeuk_res tmp/ --threads ${task.cpus} --max-intron ${max_intron}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            metaeuk: \$(metaeuk --version 2>&1 | grep -m1 '^metaeuk Version:' | sed 's/^metaeuk Version: //')
        END_VERSIONS
        """
    stub:
        """
        touch metaeuk_res.gff
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            metaeuk: \$(metaeuk --version 2>&1 | grep -m1 '^metaeuk Version:' | sed 's/^metaeuk Version: //')
        END_VERSIONS
        """
}
