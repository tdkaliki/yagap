read1=../RNA_links/Bell_1_R1.fastq.gz
read2=../RNA_links/Bell_1_R2.fastq.gz
name=Bell_1
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Dacto_1_R1.fastq.gz
read2=../RNA_links/Dacto_1_R2.fastq.gz
name=Dacto_1
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Gastro_1_R1.fastq.gz
read2=../RNA_links/Gastro_1_R2.fastq.gz
name=Gastro_1
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Gono_1_R1.fastq.gz
read2=../RNA_links/Gono_1_R2.fastq.gz
name=Gono_1
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Polyp_1_R1.fastq.gz
read2=../RNA_links/Polyp_1_R2.fastq.gz
name=Polyp_1
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Whole_1_R1.fastq.gz
read2=../RNA_links/Whole_1_R2.fastq.gz
name=Whole_1
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Bell_2_R1.fastq.gz
read2=../RNA_links/Bell_2_R2.fastq.gz
name=Bell_2
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Dacto_2_R1.fastq.gz
read2=../RNA_links/Dacto_2_R2.fastq.gz
name=Dacto_2
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Gastro_2_R1.fastq.gz
read2=../RNA_links/Gastro_2_R2.fastq.gz
name=Gastro_2
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Gono_2_R1.fastq.gz
read2=../RNA_links/Gono_2_R2.fastq.gz
name=Gono_2
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Polyp_2_R1.fastq.gz
read2=../RNA_links/Polyp_2_R2.fastq.gz
name=Polyp_2
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam

read1=../RNA_links/Whole_2_R1.fastq.gz
read2=../RNA_links/Whole_2_R2.fastq.gz
name=Whole_2
hisat2 --dta -N 1 -p 10 -x ./hisat2_index/Genome.hisat2_index -1 $read1 -2 $read2 -S ${name}.hisat2.sam --summary-file ${name}.hisat2.log
samtools view -bSu ${name}.hisat2.sam > ${name}.hisat2.bam
rm ${name}.hisat2.sam
sambamba sort -t 10 ${name}.hisat2.bam
rm ${name}.hisat2.bam
