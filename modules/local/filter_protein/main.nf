process FILTER_PROTEIN{
    label 'filter_protein'
    
    input:
        path fasta
    output:
        path "good_proteins.fasta" ,emit:fasta
        path "versions.yml", emit: versions
    script:
        """
        python filter_extended_alphabet.py ${fasta}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            python: \$(python3 --version | sed 's/^Python //')
        END_VERSIONS
        """
    stub:
        """
        touch good_proteins.fasta
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            python: \$(python3 --version | sed 's/^Python //')
        END_VERSIONS
        """    
}
