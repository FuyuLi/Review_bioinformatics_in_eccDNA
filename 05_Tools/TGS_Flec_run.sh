#Flec
#https://github.com/icebert/eccDNA_RCA_nanopore

RefFa=hg19.chrom.fa
sampleID=(CC HP)
threadnum=4

for sample in ${sampleID[*]}
do
	fqfile=${sample}_simulation.fastq
	minimap2 -x map-ont -c --secondary=no -t $threadnum $RefFa $fqfile -o $sample.aln.paf
        python eccDNA_RCA_nanopore.py  --fastq $fqfile --paf $sample.aln.paf --info $sample.info --seq $sample.seq.fa --var $sample.var --reference $RefFa
        awk '$6>0{print$6}' $sample.info |sed '1d'|grep -v '|'|awk -v FS='(' '{print $1}'|sed 's/:/\t/g'|sed 's/-/\t/g'|sort -k1,1V -k2,2n -k3,3n > $sample.singleseg.readinfo.sorted.bed
        python Script.SingleSeg.eccDNAmerge.4Flec.py $sample.singleseg.readinfo.sorted.bed $sample.singleseg
        uniq $sample.singleseg.readinfo.sorted.bed > $sample.singleseg.uniq.bed
        awk '$6>0{print$6}' $sample.info |sed '1d'|grep '|'|sed 's/(+)//g'|sed 's/(-)//g' > $sample.MS.01.readinfo.list
        python Script.MultiSeg.SegSort.py $sample.MS.01.readinfo.list $sample.MS.01.readinfo.segsort.list
        awk 'NF<3' $sample.MS.01.readinfo.segsort.list |sed 's/[-:]/\t/g'|sort -k1,1V -k2,2n -k3,3n -k4,4V -k5,5n -k6,6n |uniq -c > $sample.MS.02.2MS.sort.uniq.list
        awk 'NF>2' $sample.MS.01.readinfo.segsort.list|sort -k1,1V|uniq -c > $sample.MS.02.3MS.sort.uniq.list
        python Script.MutliSeg.eccDNAmerge.4Flec.py $sample.MS.02.2MS.sort.uniq.list $sample.MS.03.2MS.sort.uniq.merged.list
        awk '{print $1":"$2"-"$3"|"$4":"$5"-"$6,$7}' $sample.MS.03.2MS.sort.uniq.merged.list > $sample.MS.04.list
        ## CHECK $sample.MS.02.3MS.sort.uniq.list > $sample.MS.02.3MS.sort.uniq.checked.list.temp
	##sed 's/\t/|/g' $sample.MS.02.3MS.sort.uniq.checked.list.temp >> $sample.MS.04.list
done
