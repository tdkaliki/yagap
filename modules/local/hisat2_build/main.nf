process HISAT2_BUILD{
    label 'hisat2_build'
    
    input:
        path genome
    output:
        path "${genome.baseName}.hisat2_index.*" ,emit:hisat2_index
        path "versions.yml", emit: versions
    script:
        """
        #module load use.own miniconda
	#conda activate busco5

	hisat2-build ${genome} ${genome.baseName}.hisat2_index

        #cat <<-END_VERSIONS > versions.yml
        #"${task.process}":
        #    hisat2: \$(hisat2 --version)
        #END_VERSIONS
        
	touch versions.yml

	"""
    stub:
        """
        touch ${genome.baseName}.hisat2_index
        touch versions.yml
        """    
}
