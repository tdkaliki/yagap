process MAKE_REF_PROT_DB{
    label 'make_ref_prot_db'
    
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

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            mmseqs: \$(gmap --version)
        END_VERSIONS
        """
    stub:
        """
        mkdir Ref_Prot_DB
        touch versions.yml
        """
}
