include { MIKADO_CONFIGURE; MIKADO_PREPARE; MIKADO_SERIALISE; MIKADO_PICK } from '../modules/local/mikado/main'
include { DIAMOND } from '../modules/local/diamond/main'
include { TRANSDECODER } from '../modules/local/transdecoder/main'
include { METAEUK_RUN } from '../modules/local/metaeuk_run/main'
include { FILTER_METAEUK } from '../modules/local/filter_metaeuk/main'
include { MAKE_AUGUSTUS_TRAINING_SET } from '../modules/local/make_augustus_training_set/main'
include { MAKE_RNA_HINTS } from '../modules/local/make_rna_hints/main'
workflow MIKADO_RUN {
    take:
        mikado_list
		genome
        scoringfile
        protdb
        junctions
    main:
        Channel.empty().set { ch_versions }
        MIKADO_CONFIGURE(mikado_list, genome, scoringfile, protdb, junctions)
        ch_versions = ch_versions.mix(MIKADO_CONFIGURE.out.versions)
        MIKADO_PREPARE(MIKADO_CONFIGURE.out.mikado_configuration)
        ch_versions = ch_versions.mix(MIKADO_PREPARE.out.versions)
        DIAMOND(MIKADO_PREPARE.out.mikado_prepared, protdb)
        ch_versions = ch_versions.mix(DIAMOND.out.versions)
        TRANSDECODER(MIKADO_PREPARE.out.mikado_prepared)
        ch_versions = ch_versions.mix(TRANSDECODER.out.versions)
        MIKADO_SERIALISE(MIKADO_CONFIGURE.out.mikado_configuratio, DIAMOND.out.diamond_res, TRANSDECODER.out.transdecoder_res, protdb, MIKADO_PREPARE.out.mikado_prepared, junctions)
        ch_versions = ch_versions.mix(MIKADO_SERIALISE.out.versions)
        MIKADO_PICK(MIKADO_CONFIGURE.out.mikado_configuration, MIKADO_SERIALISE.out.mikado_serialise_res, MIKADO_CONFIGURE.out.mikado_scoring_copy)
        ch_versions = ch_versions.mix(MIKADO_PICK.out.versions)
        MAKE_AUGUSTUS_TRAINING_SET(MIKADO_PICK.out.mikado_metrics, MIKADO_PICK.out.mikado_gff)
        ch_versions = ch_versions.mix(MAKE_AUGUSTUS_TRAINING_SET.out.versions)
        MAKE_RNA_HINTS(MIKADO_PICK.out.mikado_gff)
        ch_versions = ch_versions.mix(MAKE_RNA_HINTS.out.versions)
        rna_hints=MAKE_RNA_HINTS.out.rna_hints
        training_set=MAKE_AUGUSTUS_TRAINING_SET.out.training_set
        mikado_annotation=MIKADO_PICK.out.mikado_gff
    emit:
        rna_hints
        training_set
        mikado_annotation
        versions = ch_versions
}
