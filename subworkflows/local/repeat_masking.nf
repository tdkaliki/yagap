include { SPLIT_GENOME } from '../modules/local/split_genome/main'
include { REPEATMASKER_WITH_MODEL; REPEATMASKER_STANDARD} from '../modules/local/repeatmasker/main'
include { LTR_FINDER } from '../modules/local/ltr_finder/main'
include { COMBINE_GFFS } from '../modules/local/combine_gffs/main'
include { GFF_TO_BED } from '../modules/local/gff_to_bed/main'
include { COMBINE_BEDS } from '../modules/local/combine_beds/main'
workflow REPEAT_MASKING {
    take:
		genome
        N
        
    main:
        Channel.empty().set { ch_versions }
        //placeholder for repat modeler
        models//modelid, model_fasta
        species=params.species

        SPLIT_GENOME(genome, N)
        ch_versions = ch_versions.mix(SPLIT_GENOME.out.versions)
        chunks_standard_model=species.combine(SPLIT_GENOME.out.genome_chunks)

        REPEATMASKER_STANDARD(chunks_standard_model)//output val, gff
        ch_versions = ch_versions.mix(REPEATMASKER_STANDARD.out.versions)
        rm_standard_gffs=REPEATMASKER_STANDARD.out.repeat_gff.map.groupTuple()
        
        if (params.run_maskin_with_model){

            models=Channel
                .fromPath(params.model_files, checkIfExists: true)
                .splitCsv(sep: '\t', header: true)
                .map { row -> 
                    [row.name, file(row.rm_model)]
                }
            chunks_with_model=models.combine(SPLIT_GENOME.out.genome_chunks)//val,fasta,genome
            REPEATMASKER_WITH_MODEL(chunks_with_model)//output val, gff
            ch_versions = ch_versions.mix(REPEATMASKER_WITH_MODEL.out.versions)
            rm_withmodel_gffs=REPEATMASKER_WITH_MODEL.out.repeat_gff.groupTuple()
            rm_gffs=rm_standard_gffs.mix(rm_withmodel_gffs)
        }
        else{
            rm_gffs=rm_standard_gffs
        }

        COMBINE_GFFS(rm_gffs)
        big_rm_gffs=COMBINE_GFF.out.gff
        if(params.run_ltr_finder){}
            LTR_FINDER(genome)//output val, gff
            ch_versions = ch_versions.mix(LTR_FINDER.out.versions)
            big_rm_gffs=COMBINE_GFF.out.gff.mix(LTR_FINDER.out.gff)
        }
        else{
            big_rm_gffs=COMBINE_GFF.out.gff
        }
       

        GFF_TO_BED(big_rm_gffs)
        bed_files=GFF_TO_BED.out.bed.map { meta, file_path -> file_path }.collect().map { file_paths -> ['repeats_beds',file_paths] }

        COMBINE_BEDS(bed_files)
        BED_SORT(COMBINE_BEDS.out.bed)
        ch_versions = ch_versions.mix(BED_SORT.out.versions)
        
        BED_MERGE(BED_SORT.out.sorted_bed)
        ch_versions = ch_versions.mix(BED_MERGE.out.versions)
        BED_MASK(genome, BED_MERGE.out.merged_bed)
        ch_versions = ch_versions.mix(BED_MASK.out.versions)
        masked_genome=BED_MASK.out.masked_genome

    emit:
        masked_genome
        versions = ch_versions
}
