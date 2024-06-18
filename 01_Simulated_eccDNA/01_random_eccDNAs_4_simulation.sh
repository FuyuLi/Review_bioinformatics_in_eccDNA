

#Script_get_PseudoReference4eccDNAs.py
#CircleBase.CancerCellLine.hg19.bed
#CircleBase.HealthyPerson.hg19.bed
#00_MultiSeg_eccDNA.fa



sampleID=(CancerCellLine HealthyPerson)

for sample in ${sampleID[*]}
do
	grep -v gl CircleBase.$sample.hg19.bed|sed '1d'|shuf - -n 5000 -o CircleBase.$sample.hg19.ran5000.bed
	bedtools getfasta -fi hg19.chrom.fa -bed CircleBase.$sample.hg19.ran5000.bed  -fo CircleBase.$sample.hg19.ran5000.fa
	cat CircleBase.$sample.hg19.ran5000.fa 00_MultiSeg_eccDNA.fa > 00_CircleBase.$sample.eccDNA4Simulation.fa
	python Script_get_PseudoReference4eccDNAs.py 00_CircleBase.$sample.eccDNA4Simulation.fa 01_CircleBase.$sample.PseudoReference4eccDNAs.fa
done
