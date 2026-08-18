process COMBINE_AUGUSTUS {
    label 'combine_augustus'
    container 'https://depot.galaxyproject.org/singularity/gffread%3A0.12.9--hf426362_0'
    input:
        tuple val(meta), path(augustus_res_files)
        path genome

    output:
        tuple val('augustus_annotation'), path("augustus_genes.gtf"), emit:augustus_annotation
        tuple val('augustus_for_mikado'), path("augustus_for_mikado.txt"), emit:augustus_for_mikado
        path "versions.yml", emit: versions
    script:
        """
        cat *.aug.out > Augustus_res.txt

        grep "\tAUGUSTUS\t" Augustus_res.txt > augustus_res.gff

        gffread augustus_res.gff -E -T -C -V -g ${genome} -o augustus_genes.gtf

        ls -d "\$PWD/"augustus_genes.gtf | awk '{print \$s "\taugustus\tTrue\t5\tTrue\tFalse\tFalse"}' > augustus_for_mikado.txt

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            gffread: \$(gffread --version)
        END_VERSIONS
        """
    stub:
        """
        touch augustus_genes.gtf
        touch augustus_for_mikado.txt
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            gffread: \$(gffread --version)
        END_VERSIONS
        """    
}

