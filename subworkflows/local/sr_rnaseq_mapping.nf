include { HISAT2_BUILD } from '../modules/local/hisat2_build/main'
include { HISAT2; HISAT2_MAPPING} from '../modules/local/hisat2/main'
include { SAM_TO_BAM } from '../modules/local/sam_to_bam/main'
include { SAMBAMBA_SORT } from '../modules/local/sambamba_sort/main'
include { SAMTOOLS_MERGE } from '../modules/local/samtools_merge/main'
include { SAMTOOLS_INDEX; SAMTOOLS_INDEX as SAMTOOLS_MERGE_INDEX } from '../modules/local/samtools_index/main'
include { STRINGTIE_HISAT } from '../modules/local/stringtie/main'
include { CREATE_HISAT_GTF_LIST } from '../modules/local/make_file_list/main'



workflow SR_RNASEQ_MAPPING {
    take:
        sr_rna_seq_reads
		genome
    main:
        Channel.empty().set { ch_versions }
        HISAT2_BUILD(genome)
        ch_versions = ch_versions.mix(HISAT2_BUILD.out.versions)
        if (params.run_clean_hisat2) {
            HISAT2_MAPPING(sr_rna_seq_reads, HISAT2_BUILD.out.hisat2_index)
            ch_versions = ch_versions.mix(HISAT2_MAPPING.out.versions)
            //hisat_bams=HISAT2_MAPPING.out.hisat2_bam.map { sample_id, file_path -> file_path }.collect().map { file_paths -> ['hisat_bam_merge',file_paths] }
            hisat_bams = HISAT2_MAPPING.out.hisat2_bam
                .map { sample_id, bam, bai -> [bam, bai] }
                .collect()
                .map { pairs -> ['hisat_bam_merge', pairs.collect{it[0]}, pairs.collect{it[1]}] }

            STRINGTIE_HISAT(HISAT2_MAPPING.out.hisat2_bam)
            ch_versions = ch_versions.mix(STRINGTIE_HISAT.out.versions)
        }
        else{
            HISAT2(sr_rna_seq_reads, HISAT2_BUILD.out.hisat2_index)
            ch_versions = ch_versions.mix(HISAT2.out.versions)
            SAM_TO_BAM(HISAT2.out.hisat2_sam)
            ch_versions = ch_versions.mix(SAM_TO_BAM.out.versions)
            SAMBAMBA_SORT(SAM_TO_BAM.out.bam_file)
            ch_versions = ch_versions.mix(SAMBAMBA_SORT.out.versions)
            SAMTOOLS_INDEX(SAMBAMBA_SORT.out.sorted_bam_file)
            ch_versions = ch_versions.mix(SAMTOOLS_INDEX.out.versions)
            //hisat_bams=SAMTOOLS_INDEX.out.bam_bai.map { sample_id, bam, bai -> [bam, bai] }.collect().map { file_paths -> ['hisat_bam_merge',file_paths] }
            hisat_bams = SAMTOOLS_INDEX.out.bam_bai
                .map { sample_id, bam, bai -> [bam, bai] }
                .collect()
                .map { pairs -> ['hisat_bam_merge', pairs.collect{it[0]}, pairs.collect{it[1]}] }




            STRINGTIE_HISAT(SAMTOOLS_INDEX.out.bam_bai)
            ch_versions = ch_versions.mix(STRINGTIE_HISAT.out.versions)
        }

        SAMTOOLS_MERGE(hisat_bams)
        ch_versions = ch_versions.mix(SAMTOOLS_MERGE.out.versions)
        SAMTOOLS_MERGE_INDEX(SAMTOOLS_MERGE.out.bam)
        ch_versions = ch_versions.mix(SAMTOOLS_MERGE_INDEX.out.versions)
        stringtie_gtfs=STRINGTIE_HISAT.out.stringtie_gtf.map { sample_id, file_path -> file_path }.collect().map { file_paths -> ['sr_rnaseq',file_paths] }
        CREATE_HISAT_GTF_LIST(stringtie_gtfs)
        
        hisat_merged_bam=SAMTOOLS_MERGE_INDEX.out.bam_bai
        hisat_list=CREATE_HISAT_GTF_LIST.out.gtf_list

    emit:
        hisat_merged_bam
        hisat_list
        versions = ch_versions
}
