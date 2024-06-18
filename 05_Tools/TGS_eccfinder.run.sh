#ecc_finder
#https://github.com/njaupan/ecc_finder

reffa=hg19.chrom.fa
sampleID=(CC HP)

for sample in ${sampleID[*]}
do
	fq=${sample}_simulation.fastq
	[ ! -d Out_eccfinder_ont ] && mkdir Out_eccfinder_ont
	python ecc_finder.py map-ont $RefFa $fq -r $RefFa -t 4 -o Out_eccfinder_ont -x $sample > Out_eccfinder_ont/Log.${sample}.eccfinder.mapont.log 2>&1
done
