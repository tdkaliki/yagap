nextflow.enable.dsl=2

include { YAGAP } from './workflows/yagap'

workflow MAIN {
    YAGAP ()
}

workflow {
    MAIN ()
}

