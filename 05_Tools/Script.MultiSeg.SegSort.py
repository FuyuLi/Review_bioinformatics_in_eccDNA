#infile = 'CC.2multiseg.check50bp.list'
#outfile = 'CC.2multiseg.check50bp.segsorted.list'

#infile = 'CC.01.MS.read.list'
#outfile = 'CC.01.MS.read.segsort.list'

#infile = 'HP.01.MS.read.list'
#outfile = 'HP.01.MS.read.segsort.list'

#!/usr/bin/env python3
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("infile", help="Multiseg eccDNAs file", type=str)
parser.add_argument("outfile", help="Output file", type=str)

args = parser.parse_args()
infile = args.infile
outfile= args.outfile



with open(outfile,"w+") as OUT:
    with open(infile,"r") as IN :
        for line in IN :
            info = line.strip().split('|')
            info.sort()
            OUT.write('\t'.join(info) + '\n')
