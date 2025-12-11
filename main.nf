nextflow.enable.dsl=2

include { YAGAP } from "$projectDir/workflows/yagap"

workflow MAIN {
    YAGAP ()
}

workflow {
    MAIN ()
}

