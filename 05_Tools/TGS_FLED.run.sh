#FLED
#https://github.com/FuyuLi/FLED

RefFa=hg19.chrom.fa
threadnum=8

sampleID=(CC HP)

for sample in ${sampleID[*]}
do
        fqfile=${sample}_simulation.fastq
	FLED Detection -ref $RefFa -fq  $fqfile -o $sample -t ${threadnum} > Log.$sample.FLED.log 2>&1
done
