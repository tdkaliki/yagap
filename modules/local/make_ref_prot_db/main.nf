process MAKE_REF_PROT_DB{
    label 'make_ref_prot_db'
    container 'https://depot.galaxyproject.org/singularity/mmseqs2%3A18.8cc5c--hd6d6fdc_0'
    input:
        path fasta
    output:
        path "Ref_Prot_DB" ,emit:ref_prot_db
        path "versions.yml", emit: versions
    script:
        """
        mkdir Ref_Prot_DB
        cd Ref_Prot_DB
        cat ../${fasta} | mmseqs createdb stdin Ref_Prot_DB
        mmseqs cluster Ref_Prot_DB Ref_Prot_clust_DB tmp/
        mmseqs createsubdb Ref_Prot_clust_DB Ref_Prot_DB Ref_Prot_RepDb
        mmseqs createsubdb Ref_Prot_clust_DB Ref_Prot_DB_h Ref_Prot_RepDb_h
        mmseqs result2profile Ref_Prot_RepDb Ref_Prot_DB Ref_Prot_clust_DB Ref_Prot_ProfileDb
        cd ../
        
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            mmseqs: \$(mmseqs --version 2>&1 | grep -m1 '^MMseqs2 Version:' | sed 's/^MMseqs2 Version: //')
        END_VERSIONS
        """
    stub:
        """
        mkdir Ref_Prot_DB
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            mmseqs: \$(mmseqs --version 2>&1 | grep -m1 '^MMseqs2 Version:' | sed 's/^MMseqs2 Version: //')
        END_VERSIONS
        """
}
