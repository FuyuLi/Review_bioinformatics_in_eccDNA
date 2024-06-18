#NanoCircle
#https://github.com/RAHenriksen/NanoCircle

RefFa=hg19.chrom.fa
threadnum=8

sampleID=(CC HP)

for sample in ${sampleID[*]}
do
	Fqfile=${sample}_simulation.fastq
	minimap2 -t 8 -ax map-ont --secondary=no  hg19.mmi $Fqfile | samtools sort - > $sample.bam
        samtools index $sample.bam
        bedtools genomecov -bg -ibam $sample.bam | bedtools merge -d 1000 -i stdin | sort -V -k1,1 -k2,2n > $sample.1000_cov.bed
        mkdir ${sample}_temp_reads
        python NanoCircle/NanoCircle_arg.py Classify --ibam $sample.bam -d ${sample}_temp_reads
        samtools index ${sample}_temp_reads/Simple_reads.bam
        samtools index ${sample}_temp_reads/Chimeric_reads.bam
        python NanoCircle/NanoCircle_arg.py Simple -i $sample.1000_cov.bed -b ${sample}_temp_reads/Simple_reads.bam -q 60 -o ${sample}_Simple_circles.bed
        python NanoCircle/NanoCircle_arg.py Chimeric -i  $sample.1000_cov.bed -b ${sample}_temp_reads/Chimeric_reads.bam -q 60 -o ${sample}_Chimeric_circles.bed
        python NanoCircle/NanoCircle_arg.py Merge -i ${sample}_Chimeric_circles.bed -o ${sample}_Merged_chimeric.bed
done
