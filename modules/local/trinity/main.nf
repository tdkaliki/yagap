process TRINITY_ASSEMBLY{
    label 'trinity'

    container 'https://depot.galaxyproject.org/singularity/trinity%3A2.15.1--h6ab5fc9_2'

    input:
        tuple val(meta), path(reads_1), path(reads_2)

    output:
        tuple val(meta), path("${meta}_Trinity.fasta"), emit: trinity_assembly
        path "versions.yml", emit: versions

    script:
        """
        Trinity \\
            --seqType fq \\
            --max_memory ${task.memory.toGiga()}G \\
            --left ${reads_1} \\
            --right ${reads_2} \\
            --CPU ${task.cpus} \\
            --output trinity_out
        mv trinity_out/Trinity.fasta ${meta}_Trinity.fasta

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            trinity: \$(Trinity --version | grep -oP 'Trinity-v\\S+' | sed 's/Trinity-v//')
        END_VERSIONS
        """
}