#Circle_finder
#https://github.com/pk7zuva/Circle_finder

reffa=hg19.chrom.fa
sampleID=(CC HP)

for sample in ${sampleID[*]}
do
		fq1=${sample}_simulation_1.fq
		fq2=${sample}_simulation_2.fq
		bash circle_finder-pipeline-bwa-mem-samblaster.sh 8 $reffa $fq1 $fq2 10 $sample hg19
		sort -k1,1V -k2,2n -k3,3n ${sample}-hg19.microDNA-JT.txt > ${sample}-hg19.microDNA-JT.sorted.bed
		python Script.SingleSeg.eccDNAmerge.4CircleFinder.py ${sample}-hg19.microDNA-JT.sorted.bed ${sample}
done

