#ecc_finder
#https://github.com/njaupan/ecc_finder

reffa=hg19.chrom.fa
sampleID=(CC HP)

for sample in ${sampleID[*]}
do
	fq1=${sample}_simulation_1.fq
	fq2=${sample}_simulation_2.fq
	[ ! -d Out_eccfinder_sr ] && mkdir Out_eccfinder_sr
	python ecc_finder.py map-sr $RefFa $fq1 $fq2 -r $RefFa -t 12 -o Out_eccfinder_sr -x $sample > Out_eccfinder_sr/Log.${sample}.eccfinder.mapsr.log 2>&1
done
