include { GMAP_BUILD } from '../modules/local/gmap_build/main'
include { GMAP_MAPPING } from '../modules/local/gmap_mapping/main'
include { CREATE_GMAP_GFF_LIST } from '../modules/local/make_file_list/main'

workflow TRINITY_MAPPING {
    take:
        trinity_fasta
		genome
    main:
        Channel.empty().set { ch_versions }
        GMAP_BUILD(genome)
        ch_versions = ch_versions.mix(GMAP_BUILD.out.versions)
        GMAP_MAPPING(trinity_fasta, GMAP_BUILD.out.gmapdb, GMAP_BUILD.out.genomedb)
        ch_versions = ch_versions.mix(GMAP_MAPPING.out.versions)
        gmap_gffs=GMAP_MAPPING.out.gff.map { sample_id, file_path -> file_path }.collect().map { file_paths -> ['trinity',file_paths] }
        CREATE_GMAP_GFF_LIST(gmap_gffs)
        gmap_list=CREATE_GMAP_GFF_LIST.out.gff_list
    emit:
        gmap_list
        versions = ch_versions
}
