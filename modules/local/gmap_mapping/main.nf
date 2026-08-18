process GMAP_MAPPING{
    label 'gmap_mapping'
    container 'https://depot.galaxyproject.org/singularity/gmap%3A2025.07.31--pl5321hb1d24b7_1'
    input:
        tuple val(sample_id), path(fasta)
        path gmapdb
        //path genomedb

    output:
        tuple val(sample_id), path("${sample_id}.gff3"),emit:gff
        path "versions.yml", emit: versions
    script:
        """
        #gmap -D ${gmapdb} -d ${genomedb} -f 3 -n 0 -x 50 -t 10 -B 4 --gff3-add-separators=0 ${fasta} > ${sample_id}.gff3
        gmap -D ${gmapdb} -d Genome -f 3 -n 0 -x 50 -t 10 -B 4 --gff3-add-separators=0 ${fasta} > ${sample_id}.gff3

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            gmap: \$(gmap --version 2>&1 | grep -oP 'version \\K[\\d-]+')
        END_VERSIONS
        """
    stub:
        """
        touch ${sample_id}.gff3
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            gmap: \$(gmap --version 2>&1 | grep -oP 'version \\K[\\d-]+')
        END_VERSIONS
        """    
}
