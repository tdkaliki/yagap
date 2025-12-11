include { FILTER_PROTEIN } from '../modules/local/filter_protein/main'
include { MAKE_REF_PROT_DB } from '../modules/local/make_ref_prot_db/main'
include { METAEUK_DB } from '../modules/local/metaeuk_db/main'
include { METAEUK_RUN } from '../modules/local/metaeuk_run/main'
include { FILTER_METAEUK } from '../modules/local/filter_metaeuk/main'

workflow PROTEIN_MAPPING {
    take:
        protein_fa
		genome
    main:
        Channel.empty().set { ch_versions }
        FILTER_PROTEIN(protein_fa)
        ch_versions = ch_versions.mix(FILTER_PROTEIN.out.versions)
        MAKE_REF_PROT_DB(FILTER_PROTEIN.out.fasta)
        ch_versions = ch_versions.mix(MAKE_REF_PROT_DB.out.versions)
        METAEUK_DB(genome)
        ch_versions = ch_versions.mix(METAEUK_DB.out.versions)
        METAEUK_RUN(FILTER_PROTEIN.out.fasta, METAEUK_DB.out.genome_db, MAKE_REF_PROT_DB.out.ref_prot_db, params.max_intron )
        ch_versions = ch_versions.mix(METAEUK_RUN.out.versions)
        FILTER_METAEUK(METAEUK_RUN.out.metaeuk_gff)
        ch_versions = ch_versions.mix(FILTER_METAEUK.out.versions)
        protein_hints=FILTER_METAEUK.out.FILTER_METAEUK
    emit:
        protein_hints
        versions = ch_versions
}
