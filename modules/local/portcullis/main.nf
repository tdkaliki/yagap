process PORTCULIS{
    label 'portculis'
    //container 'https://depot.galaxyproject.org/singularity/portcullis%3A1.2.4--py312hdf7dc61_5'
    container 'https://depot.galaxyproject.org/singularity/portcullis%3A1.2.3--py39h66ddb4a_0'
    input:
        tuple val(meta_info), path(bam_file), path(bai_file)
        path genome
    output:
        tuple val("portculis_junctions_bed"), path("portcullis_rezults/3-filt/portcullis_filtered.pass.junctions.bed"),emit:junctions_bed
        path "versions.yml", emit: versions
    script:
        """
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            portcullis: \$(portcullis --version| sed 's/^portcullis //')
        END_VERSIONS

        portcullis full -t ${task.cpus} -v --bam_filter --orientation FR -o portcullis_rezults ${genome} ${bam_file}

        """
    stub:
        """
        mkdir -p portcullis_rezults/3-filt
        touch portcullis_rezults/3-filt/portcullis_filtered.pass.junctions.bed
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            portcullis: \$(portcullis --version| sed 's/^portcullis //')
        END_VERSIONS
        """
}
