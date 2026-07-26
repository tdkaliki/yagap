process METAEUK_DB{
    label 'metaeuk_db'
    container 'https://depot.galaxyproject.org/singularity/metaeuk%3A7.bba0d80--pl5321hd6d6fdc_2'
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
