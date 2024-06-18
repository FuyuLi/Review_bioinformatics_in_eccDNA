import argparse
from collections import defaultdict
from scipy import stats


parser = argparse.ArgumentParser()
parser.add_argument("bed_file", help="sorted bed file for merge", type=str)
parser.add_argument("prefix_outfile", help="prefix of outfile", type=str)

args = parser.parse_args()
FileA = args.bed_file
labelA = args.prefix_outfile


##INPUT FORMAT : CHROM START END READNUM 
##input bed must be sorted by :sort -k1,1V -k2,2n -k3,3n


merge_dist = 50



class Junction(object) :
    def __init__(self, info):
        self.chrom = info[0]
        self.start = int(info[1])
        self.end = int(info[2])
        self.readNum = int(info[3])
        self.attr = '\t'.join(info)


def junction_read(bedfile):
    indata = defaultdict(str)
    juncs = []
    bednum=1
    with open(bedfile, 'r') as JuncAFile :
        for line in JuncAFile :
            A = Junction(line.strip().split('\t'))
#            junc = [A.chrom, A.start, A.end, A.readNum, "bed"+str(bednum), A.attr]
            juncs.append([A, "bed"+str(bednum)])
            indata["bed"+str(bednum)] = A.attr
            bednum += 1
    return(juncs, indata)


def junction_cluster(data, maxgap):
#    data.sort()
    groups = [[data[0]]]
    for x in data[1:]:
        newGroup = True
        for group in groups[-5:] :
            if (x[0].chrom == group[-1][0].chrom) and (abs(x[0].start - group[-1][0].start) <= maxgap) and (abs(x[0].end - group[-1][0].end) <= maxgap) :
                group.append(x)
                newGroup = False
                break
        if newGroup == True :
                groups.append([x])
    return groups


juncs, indata = junction_read(FileA)
groups = junction_cluster(juncs, merge_dist)



def write_into_file(Alabel, oridata, groups) :
 with open(''.join([Alabel, '_unmerged.bed']),"w+") as orifile :
  with open(''.join([Alabel, '_merged.bed']),"w+") as merfile :
    for item in oridata :
        record = item + '\t' + oridata[item] + '\n'
        orifile.write(record)
    for group in groups:
        mergedecc = group[0][0]
        eccid = [group[0][1]]
        readSum = mergedecc.readNum
        for ecc in group[1:] :
            if ecc[0].readNum >= mergedecc.readNum :
                mergedecc = ecc[0]
            readSum += ecc[0].readNum
            eccid.append(ecc[1])
        record = '\t'.join([mergedecc.chrom, str(mergedecc.start), str(mergedecc.end), str(readSum), ','.join(eccid)]) + '\n'
        merfile.write(record)



write_into_file(labelA, indata, groups)


