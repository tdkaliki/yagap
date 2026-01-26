#!/bin/sh
#$ -cwd
#$ -pe smp 2
#$ -l h_vmem=4G
#$ -l h_rt=1:0:0
#$ -j y


#module load HGI/common/nextflow/24.10.4
module load nextflow

export NXF_OPTS="-Xms8G -Xmx8G"

work_dir=$1

nextflow run /data/home/btx717/storage/01-ademendoza/software/yagap -stub-run -w $work_dir -resume -with-trace -with-report --verbose
