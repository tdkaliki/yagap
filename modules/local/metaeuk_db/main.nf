process METAEUK_DB{
    label 'metaeuk_db'
    
    input:
        path genome
    output:
        path "Genome.DB" ,emit:genome_db
        path "versions.yml", emit: versions
    script:
        """
        metaeuk createdb ${genome} Genome.DB

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            metaeuk: \$(metaeuk --version)
        END_VERSIONS
        """
    stub:
        """
        touch Genome.DB
        touch versions.yml
        """
}
