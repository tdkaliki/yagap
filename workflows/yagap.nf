include { PROTEIN_MAPPING } from '../subworkflows/local/protein_mapping'
include { TRINITY_MAPPING } from '../subworkflows/local/trinity_mapping'
include { CDNASEQ_MAPPING } from '../subworkflows/local/cdna_seq_mapping'
include { LR_RNASEQ_MAPPING } from '../subworkflows/local/lr_rnaseq_mapping'
include { SR_RNASEQ_MAPPING } from '../subworkflows/local/sr_rnaseq_mapping'
include { GET_JUNCTIONS } from '../subworkflows/local/junctions'
include { MIKADO_RUN; MIKADO_RUN as MIKADO_RUN_AFTER_AUGUSTUS } from '../subworkflows/local/mikado_run'
include { COMBINE_MIKADO_LIST as COMBINE_MIKADO_LIST1; COMBINE_MIKADO_LIST as COMBINE_MIKADO_LIST2} from '../modules/local/combine_mikado_list'
include { COMBINE_HINTS } from '../modules/local/combine_hints'
include { AUGUSTUS_ANNOTATION } from '../subworkflows/local/augustus_annotation'
include { REPEAT_MASKING } from '../subworkflows/local/repeat_masking'

workflow YAGAP {
    main:
    mikado_gtf_list = Channel.empty()
    augustus_hints = Channel.empty()
    ch_versions = Channel.empty()
///
    if (params.run_trinity_mapping) {
        trinity_fa=Channel
            .fromPath(params.trinity_files, checkIfExists: true)
            .splitCsv(sep: '\t', header: true)
            .map { row -> 
                [row.sample_id, file(row.trinity_fasta)]
            }
        TRINITY_MAPPING(trinity_fa, params.genome)
        mikado_gtf_list = mikado_gtf_list.mix(TRINITY_MAPPING.out.gmap_list)
        ch_versions = ch_versions.mix(TRINITY_MAPPING.out.versions)
    }
///
    if (params.run_cdna_mapping) {
        cdna_seq=Channel
            .fromPath(params.cdna_seq, checkIfExists: true)
            .splitCsv(sep: '\t', header: true)
            .map { row -> 
                [row.sample_id, file(row.cdna_fastq)]
            }
        CDNASEQ_MAPPING(cdna_seq, params.genome)
        mikado_gtf_list = mikado_gtf_list.mix(CDNASEQ_MAPPING.out.minimap_list)
        ch_versions = ch_versions.mix(CDNASEQ_MAPPING.out.versions)
    }
///
    if (params.run_lr_mapping) {
        lr_rna_seq_reads=Channel
            .fromPath(params.lr_rnaseq_reads, checkIfExists: true)
            .splitCsv(sep: '\t', header: true)
            .map { row -> 
                [row.sample_id, file(row.lr_rna_fastq)]
            }
        LR_RNASEQ_MAPPING(lr_rna_seq_reads, params.genome)
        mikado_gtf_list = mikado_gtf_list.mix(LR_RNASEQ_MAPPING.out.minimap_list)
        ch_versions = ch_versions.mix(LR_RNASEQ_MAPPING.out.versions)
    }
///
    sr_rna_seq_reads=Channel
        .fromPath(params.sr_rnaseq_reads, checkIfExists: true)
        .splitCsv(sep: '\t', header: true)
        .map { row -> 
            [row.sample_id, file(row.read1), file(row.read2)]
        }
    SR_RNASEQ_MAPPING(sr_rna_seq_reads, params.genome)
    //SR_RNASEQ_MAPPING.out.bam_file
    mikado_gtf_list = mikado_gtf_list.mix(SR_RNASEQ_MAPPING.out.hisat_list)
    ch_versions = ch_versions.mix(SR_RNASEQ_MAPPING.out.versions)
    ///
    GET_JUNCTIONS(SR_RNASEQ_MAPPING.out.hisat_merged_bam, params.genome)
    //GET_JUNCTIONS.out.junctions
    augustus_hints = augustus_hints.mix(GET_JUNCTIONS.out.intron_hints)
    ch_versions = ch_versions.mix(GET_JUNCTIONS.out.versions)
    ///
    mikado_gtf_list1 = mikado_gtf_list
        .map { meta, path -> path }  // Extract just the paths
        .collect()  // Collect all paths into a single list
        .map { all_paths -> 
            ['combine_gtfs_for_mikado', all_paths]  // Create new structure
        }
    COMBINE_MIKADO_LIST1(mikado_gtf_list1)
    ///
    MIKADO_RUN(COMBINE_MIKADO_LIST1.out.mikado_list, params.genome, params.scoringfile, params.protdbfas, GET_JUNCTIONS.out.junctions)
    augustus_hints = augustus_hints.mix(MIKADO_RUN.out.rna_hints)
    //MIKADO_RUN.out.training_set
    ch_versions = ch_versions.mix(MIKADO_RUN.out.versions)

///
    //genome masking
    if (params.run_masking) {
        REPEAT_MASKING(params.genome, params.number_of_chunks)
        ch_versions = ch_versions.mix(REPEAT_MASKING.out.versions)
        genome_sm=REPEAT_MASKING.out.masked_genome
    }
    else{
        genome_sm=params.genome
    }
///
    if (params.run_augustus){
///
        if (params.run_protein_mapping) {
            PROTEIN_MAPPING(params.protein_fasta, params.genome)
            augustus_hints = augustus_hints.mix(PROTEIN_MAPPING.out.protein_hints)
            ch_versions = ch_versions.mix(PROTEIN_MAPPING.out.versions)
        }
///
        augustus_hints = augustus_hints
            .map { meta, path -> path }  // Extract just the paths
            .collect()  // Collect all paths into a single list
            .map { all_paths -> 
                ['combine_hints', all_paths]  // Create new structure
            }

        COMBINE_HINTS(augustus_hints)

        AUGUSTUS_ANNOTATION(genome_sm, MIKADO_RUN.out.training_set, COMBINE_HINTS.out.augustus_hints, params.number_of_chunks)
        //AUGUSTUS_ANNOTATION.out.augustus_annotation
        AUGUSTUS_ANNOTATION.out.augustus_for_mikado
        ch_versions = ch_versions.mix(AUGUSTUS_ANNOTATION.out.versions)
        if(params.run_mikado_after_augustus){
            mikado_gtf_list=mikado_gtf_list.mix(AUGUSTUS_ANNOTATION.out.augustus_for_mikado)
            mikado_gtf_list2 = mikado_gtf_list
                .map { meta, path -> path }  // Extract just the paths
                .collect()  // Collect all paths into a single list
                .map { all_paths -> 
                    ['combine_gtfs_for_mikado', all_paths]  // Create new structure
            }
            COMBINE_MIKADO_LIST2(mikado_gtf_list2)
            MIKADO_RUN_AFTER_AUGUSTUS(COMBINE_MIKADO_LIST2.out.mikado_list, params.genome, params.scoringfile, params.protdb, GET_JUNCTIONS.out.junctions)
            MIKADO_RUN_AFTER_AUGUSTUS.out.mikado_annotation
            ch_versions = ch_versions.mix(MIKADO_RUN.out.versions)
        }
    }
}