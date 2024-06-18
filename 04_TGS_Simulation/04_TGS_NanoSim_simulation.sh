simulator.py linear -r 01_CircleBase.CancerCellLine.PseudoReference4eccDNAs.fa  -c RealData_training -o Sim_CC -n 1600000
simulator.py linear -r 01_CircleBase.HealthyPerson.PseudoReference4eccDNAs.fa -c RealData_training -o Sim_HP -n 1600000
simulator.py linear -r hg19.chrom.withSV.fasta -c RealData_training -o SVgenomes -n 400000

sampleID=(CC HP)
for sample in ${sampleID[*]}
do
	cat Sim_${sample}_reads.fasta SVgenomes_reads.fasta > ${sample}_simulation.fasta
	python Script_fa2fq.py --fa ${sample}_simulation.fasta --fastq ${sample}_simulation.fastq
done
