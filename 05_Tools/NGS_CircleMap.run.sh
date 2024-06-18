#Circle-Map
#https://github.com/iprada/Circle-Map

reffa=hg19.chrom.fa
threadnum=8

sampleID=(CC HP)
for sample in ${sampleID[*]}
do
	fqFile1=${sample}_simulation_1.fq
	fqFile2=${sample}_simulation_2.fq
	echo Circle-Map for sample $sample Start!
	[ ! -d $sample ] && mkdir $sample
	bwa mem -t $threadnum -q $RefFa $fqFile1 $fqFile2 -o $sample/$sample.sam > $sample/Log.$sample.BWAmem.log 2>&1
	echo Alignment Done!
	samtools view -bS -@ $threadnum $sample/$sample.sam -o $sample/$sample.bam
	samtools sort -@ $threadnum $sample/$sample.bam -o $sample/$sample.coord.bam
	samtools sort -n -@ $threadnum $sample/$sample.bam -o $sample/$sample.qname.bam
	samtools index -@ $threadnum $sample/$sample.coord.bam
	echo sorting sam by samtools Done!
	Circle-Map ReadExtractor -i $sample/$sample.qname.bam -o $sample/$sample.circular_read_candidates.bam > $sample/Log.$sample.ReadExtractor.log 2>&1
	samtools sort -@ $threadnum -o $sample/$sample.sorted_circular_read_candidates.bam $sample/$sample.circular_read_candidates.bam
	samtools index -@ $threadnum $sample/$sample.sorted_circular_read_candidates.bam
	echo Circle-Map ReadExtractor Done!
	Circle-Map Realign -t $threadnum -i $sample/$sample.sorted_circular_read_candidates.bam -qbam $sample/$sample.qname.bam -sbam $sample/$sample.coord.bam -fasta $RefFa -o $sample/$sample.CircleMap.out.bed > $sample/Log.$sample.Realign.log 2>&1
	echo Circle-Map Realign Done!
	echo $sample CircleMap Done!
done
