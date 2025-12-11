include { AUGUSTUS_TRAINING } from '../modules/local/augustus_training/main'
include { AUGUSTUS_RUN } from '../modules/local/augustus_run/main'
include { SPLIT_GENOME } from '../modules/local/split_genome/main'
include { COMBINE_AUGUSTUS } from '../modules/local/combine_augustus/main'

workflow MIKADO_RUN {
    take:
        genome
		training_set
        augustus_hints
        N
    main:
        Channel.empty().set { ch_versions }
        AUGUSTUS_TRAINING(training_set, genome, params.augustus_specname)
        ch_versions = ch_versions.mix(AUGUSTUS_TRAINING.out.versions)
        SPLIT_GENOME(genome, N)
        ch_versions = ch_versions.mix(SPLIT_GENOME.out.versions)
        genome_chunks = SPLIT_GENOME.out.genome_chunks
        .flatten()
        .map { chunk_file ->
            def chunk_id = chunk_file.name.replaceAll(/.*_part_(\d+)$/, '$1')
            ["chunk_${chunk_id}", chunk_file]
        }
        AUGUSTUS_RUN(augustus_hints, AUGUSTUS_TRAINING.out.specname, genome_chunks)
        ch_versions = ch_versions.mix(AUGUSTUS_RUN.out.versions)
        augustus_res=AUGUSTUS_RUN.out.augustus_out.map { genome_id, file_path -> file_path }.collect().map { file_paths -> ['augustus_results',file_paths] }
        COMBINE_AUGUSTUS(augustus_res, genome)
        ch_versions = ch_versions.mix(COMBINE_AUGUSTUS.out.versions)

        augustus_annotation=COMBINE_AUGUSTUS.out.augustus_annotation
        augustus_for_mikado=COMBINE_AUGUSTUS.out.augustus_for_mikado
    emit:
        augustus_annotation
        augustus_for_mikado
        versions = ch_versions
}
