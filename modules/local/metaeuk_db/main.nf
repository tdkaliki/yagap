process METAEUK_DB{
    label 'metaeuk_db'
    container 'https://depot.galaxyproject.org/singularity/metaeuk%3A7.bba0d80--pl5321hd6d6fdc_2'
    input:
        path genome
    output:
        tuple val("Genome.DB"), path("Genome.DB*") ,emit:genome_db
        path "versions.yml", emit: versions
    script:
        """
        metaeuk createdb ${genome} Genome.DB

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            metaeuk: \$(metaeuk --version 2>&1 | grep -m1 '^metaeuk Version:' | sed 's/^metaeuk Version: //')
        END_VERSIONS
        """
    stub:
        """
        touch Genome.DB
        touch Genome.DB.dbtype
        touch Genome.DB_h
        touch Genome.DB_h.dbtype
        touch Genome.DB_h.index
        touch Genome.DB.index
        touch Genome.DB.lookup
        touch Genome.DB.source
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            metaeuk: \$(metaeuk --version 2>&1 | grep -m1 '^metaeuk Version:' | sed 's/^metaeuk Version: //')
        END_VERSIONS
        """
}
