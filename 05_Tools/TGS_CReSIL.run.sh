#CReSIL
#https://github.com/visanuwan/cresil

RefFa=hg19.chrom.fa
threadnum=8

sampleID=(CC HP)

for sample in ${sampleID[*]}
do
	fqfile=${sample}_simulation.fastq
	cresil trim -t $threadnum -fq $fqfile -r hg19.chrom.mmi -o cresil_result
	cresil identify -t $threadnum -fa $RefFa -fai $RefFa.fai -fq $fqfile -trim cresil_result/trim.txt
	mv cresil_result ${sample}_cresil_result
done
