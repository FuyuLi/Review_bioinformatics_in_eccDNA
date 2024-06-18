#!/usr/bin/env python3
# -*- coding:utf-8 -*-
# @Time  : 2023/08/29 16:06
# @Author: lify
# @File  : bed_merge.py


import argparse
from collections import defaultdict
from scipy import stats


parser = argparse.ArgumentParser()
parser.add_argument("bed_file", help="bed file for merge", type=str)
parser.add_argument("prefix_outfile", help="prefix of outfile", type=str)

args = parser.parse_args()
FileA = args.bed_file
labelA = args.prefix_outfile



merge_dist = 50



class Junction(object) :
    def __init__(self, info):
        self.chrom = info[0]
        self.start = int(info[1])
        self.end = int(info[2])
        self.attr = '\t'.join(info)





def junction_read(bedfile):
    indata = defaultdict(str)
    juncs = []
    bednum=1
    with open(bedfile, 'r') as JuncAFile :
        for line in JuncAFile :
            A = Junction(line.strip().split('\t'))
            junc = [A.chrom, A.start, A.end, "bed"+str(bednum), A.attr]
            juncs.append(junc)
            indata["bed"+str(bednum)] = A.attr
            bednum += 1
    return(juncs, indata)

def junction_cluster(data, maxgap):
    data.sort()
    groups = [[data[0]]]
    for x in data[1:]:
        newGroup = True
        for group in groups[-5:] :
            if (x[0] == group[-1][0]) and (abs(x[1] - group[-1][1]) <= maxgap) and (abs(x[2] - group[-1][2]) <= maxgap) :
                group.append(x)
                newGroup = False
                break
        if newGroup == True :
                groups.append([x])
    return groups



def junction_merge(groups):
    readslist = {} ## merger_bed: unmerged_bed_list
    for clusteri in groups:
        chrom = clusteri[0][0]
        starts = []
        ends = []
        reads = []
        strands = []
        for seg in clusteri :
            starts.append(seg[1])
            ends.append(seg[2])
            reads.append(seg[3])
        StartPos = stats.mode(starts)[0][0]
        EndPos = stats.mode(ends)[0][0]
        junc = '\t'.join([chrom,  str(StartPos), str(EndPos)])
        readslist[junc] = reads
    return(readslist)





def write_into_file(Alabel, oridata, mergeddata) :
    orifile = open(''.join([Alabel, '_unmerged.bed']),"w+")
    merfile = open(''.join([Alabel, '_merged.bed']),"w+")
    for item in oridata :
        record = item + '\t' + oridata[item] + '\n'
        orifile.write(record)
    for item in mergeddata :
        record = item + '\t' + ';'.join(mergeddata[item]) + '\n'
        merfile.write(record)
    orifile.close()
    merfile.close()
    return(True)





juncs, indata = junction_read(FileA)
groups = junction_cluster(juncs, merge_dist)
merged = junction_merge(groups)
write_into_file(labelA, indata, merged)
