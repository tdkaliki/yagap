process SPLIT_GENOME {
    label "split_genome"
    
    input:
        path genome_fasta
        val N
    
    output:
        path "${genome_fasta.baseName}_part_*", emit: genome_chunks
        path "versions.yml", emit: versions
    
    script:
        """
        if [ ${N} -gt 1 ]; then
            fastasplit -f ${genome_fasta} -o ./ -c ${N}
    
            ls -1 ${genome_fasta}_chunk_* > GENOME_CHUNKS.txt
    
            i="1"
            for i in \$(seq 1 ${N}); do
                file=\$(head -n \$i GENOME_CHUNKS.txt | tail -n 1)
                mv \$file ${genome_fasta.baseName}_part_"\$i" &
                i=\$[\$i+1]
            done
        else
            mv ${genome_fasta} ${genome_fasta.baseName}_part_1
        fi

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
        fastasplit: \$(fastasplit --version 2>&1 | grep -oP 'fastasplit \\K[0-9.]+' || echo "1.0.0")
        END_VERSIONS
        """
    stub:
        """
        i="1"
        for i in \$(seq 1 ${N}); do
            touch ${genome_fasta.baseName}_part_\${i}
        done
        touch versions.yml
        """
}
