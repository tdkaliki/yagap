include { PORTCULIS } from '../../modules/local/portcullis/main'
include { JUNCTOOLS } from '../../modules/local/junctools/main'

workflow GET_JUNCTIONS {
    take:
        bam_file
		genome
    main:
        Channel.empty().set { ch_versions }
        PORTCULIS(bam_file, genome)
        ch_versions = ch_versions.mix(PORTCULIS.out.versions)
        JUNCTOOLS(PORTCULIS.out.junctions_bed)
        ch_versions = ch_versions.mix(JUNCTOOLS.out.versions)
        junctions=PORTCULIS.out.junctions_bed
        intron_hints=JUNCTOOLS.out.intron_hints
    emit:
        junctions
        intron_hints
        versions = ch_versions
}
