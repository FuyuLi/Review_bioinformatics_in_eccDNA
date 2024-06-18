#!/usr/bin/env python3

#infile = 'CC.02.2MS.sort.uniq.list'
#outfile = 'CC.03.2MS.sort.uniq.merged.list'
#outfile = 'CC.03.2MS.sort.uniq.merged100bp.list'
#infile = 'HP.02.2MS.sort.uniq.list'
#outfile = 'HP.03.2MS.sort.uniq.merged.list'


import argparse

parser = argparse.ArgumentParser()
parser.add_argument("infile", help="Multiseg eccDNAs file", type=str)
parser.add_argument("outfile", help="Output file", type=str)

args = parser.parse_args()
infile = args.infile
outfile= args.outfile


maxgap = 50
#maxgap = 100

class Junction(object) :
    def __init__(self, info):
        self.readNum = int(info[0].split(' ')[0])
        self.chrom1 = info[0].split(' ')[1]
        self.start1 = int(info[1])
        self.end1 = int(info[2])
        self.chrom2 = info[3]
        self.start2 = int(info[4])
        self.end2 = int(info[5])
        self.attr = '\t'.join(info)



eccDNAlist = []
with open(infile,"r") as IN :
    for line in IN :
        info = line.strip().split('\t')
        eccDNA = Junction(info)
        eccDNAlist.append(eccDNA)


def junction_cluster(data, maxgap):
    groups = [[data[0]]]
    for x in data[1:]:
        newGroup = True
        for group in groups[-5:] :
            if (x.chrom1 == group[-1].chrom1) and (abs(x.start1 - group[-1].start1) <= maxgap) and (abs(x.end1 - group[-1].end1) <= maxgap) and (x.chrom2 == group[-1].chrom2) and (abs(x.start2 - group[-1].start2) <= maxgap) and (abs(x.end2 - group[-1].end2) <= maxgap):
                group.append(x)
                newGroup = False
                break
        if newGroup == True :
                groups.append([x])
    return groups



groups = junction_cluster(eccDNAlist, maxgap)
mergedlist = []
with open(outfile,"w+") as OUT :
 for group in groups:
    mergedecc = group[0]
    readSum = mergedecc.readNum
    for ecc in group[1:] :
        if ecc.readNum >= mergedecc.readNum :
            mergedecc = ecc
        readSum += ecc.readNum
    record = '\t'.join([mergedecc.chrom1,str(mergedecc.start1),str(mergedecc.end1),mergedecc.chrom2,str(mergedecc.start2),str(mergedecc.end2),str(readSum)])
    OUT.write(record + '\n')   
    







