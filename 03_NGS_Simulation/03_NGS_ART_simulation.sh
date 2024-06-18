art_illumina -ss HS25 -i 01_CircleBase.CancerCellLine.PseudoReference4eccDNAs.fa -p -l 150 -f 50 -m 300 -s 20 -o ArtSim_CC > Log.CC.art_illumina.log
art_illumina -ss HS25 -i 01_CircleBase.HealthyPerson.PseudoReference4eccDNAs.fa -p -l 150 -f 70 -m 300 -s 20 -o ArtSim_HP > Log.HP.art_illumina.log
art_illumina -ss HSXt -i hg19.chrom.withSV.fasta -p -l 150 -f 1 -m 300 -s 20 -o ArtSim_SV > Log.SV.art_illumina.log

sampleID=(CC HP)
for sample in ${sampleID[*]}
do
	cat ArtSim_${sample}1.fq ArtSim_SV1.fq > ${sample}_simulation_1.fq
	cat ArtSim_${sample}2.fq ArtSim_SV2.fq > ${sample}_simulation_2.fq
done

