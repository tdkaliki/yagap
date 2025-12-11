process METAEUK_RUN{
    label 'metaeuk_run'
    
    input:
        path fasta
        path genome_db
        path ref_prot_db
        val max_intron
    output:
        path "metaeuk_res.gff" ,emit:metaeuk_gff
        path "versions.yml", emit: versions
    script:
        """
        metaeuk easy-predict ${genome_db} ${ref_prot_db}/Ref_Prot_ProfileDb metaeuk_res tmp/ --threads ${task.cpus} --max-intron ${max_intron}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            metaeuk: \$(metaeuk --version)
        END_VERSIONS
        """
    stub:
        """
        touch metaeuk_res.gff
        touch versions.yml
        """
}
