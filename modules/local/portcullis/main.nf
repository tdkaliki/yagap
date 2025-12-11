process PORTCULIS{
    label 'portculis'
    
    input:
        tuple val(meta_info), path(bam_file), path(bai_file)
        path genome
    output:
        tuple val(new_meta_info), path("portcullis_rezults/3-filt/portcullis_filtered.pass.junctions.bed"),emit:junctions_bed
        path "versions.yml", emit: versions
    script:
        new_meta_info = "portculis_junctions_bed"
        """
        portcullis full -t ${task.cpus} -v --bam_filter --orientation FR -o portcullis_rezults ${genome} ${bam_file}

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            portcullis: \$(portcullis --version)
        END_VERSIONS
        """
    stub:
        """
        mkdir -p portcullis_rezults/3-filt
        touch portcullis_rezults/3-filt/portcullis_filtered.pass.junctions.bed
        touch versions.yml
        """
}
