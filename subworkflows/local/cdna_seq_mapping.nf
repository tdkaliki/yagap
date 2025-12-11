include { MINIMAP2_CDNA; MINIMAP2_CDNA_MAPPING} from '../modules/local/hisat2/main'
include { SAM_TO_BAM } from '../modules/local/sam_to_bam/main'
include { SAMTOOLS_SORT } from '../modules/local/samtools_sort/main'
include { SAMTOOLS_INDEX } from '../modules/local/samtools_index/main'
include { STRINGTIE_MINIMAP } from '../modules/local/stringtie/main'
include { CREATE_MINIMAP_GTF_LIST } from '../modules/local/make_file_list/main'

workflow CDNASEQ_MAPPING {
    take:
        cdna_seq
		genome
    main:
        Channel.empty().set { ch_versions }
        if (params.run_clean_minimap2) {
            MINIMAP2_CDNA_MAPPING(cdna_seq, genome)
            ch_versions = ch_versions.mix(MINIMAP2_CDNA_MAPPING.out.versions)
            STRINGTIE_MINIMAP(MINIMAP2_CDNA_MAPPING.out.minimap2_bam)
            ch_versions = ch_versions.mix(STRINGTIE_MINIMAP.out.versions)
        }
        else{
            MINIMAP2_CDNA(cdna_seq, genome)
            ch_versions = ch_versions.mix(MINIMAP2_CDNA.out.versions)
            SAM_TO_BAM(MINIMAP2_CDNA.out.minimap2_sam)
            ch_versions = ch_versions.mix(SAM_TO_BAM.out.versions)
            SAMTOOLS_SORT(SAM_TO_BAM.out.bam_file)
            ch_versions = ch_versions.mix(SAMTOOLS_SORT.out.versions)
            SAMTOOLS_INDEX(SAMTOOLS_SORT.out.sorted_bam)
            ch_versions = ch_versions.mix(SAMTOOLS_INDEX.out.versions)
            STRINGTIE_MINIMAP(SAMTOOLS_INDEX.out.bam_bai)
            ch_versions = ch_versions.mix(STRINGTIE_MINIMAP.out.versions)
        }

        stringtie_gtfs=STRINGTIE_MINIMAP.out.stringtie_gtf.map { sample_id, file_path -> file_path }.collect().map { file_paths -> ['cdna_seq',file_paths] }
        CREATE_MINIMAP_GTF_LIST(stringtie_gtfs)
        minimap_list=CREATE_MINIMAP_GTF_LIST.out.gtf_list

    emit:
        minimap_list
        versions = ch_versions
}
