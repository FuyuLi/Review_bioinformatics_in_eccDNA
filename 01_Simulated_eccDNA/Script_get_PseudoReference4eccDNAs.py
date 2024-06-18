from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import argparse



#infile = '00_CircleBase.HealthyPerson.eccDNA4Simulation.fa'
#outfile = '01_CircleBase.HealthyPerson.PseudoReference4eccDNAs.fa'

parser = argparse.ArgumentParser()
parser.add_argument("Infile", help="In File", type=str)
parser.add_argument("Outfile", help="Out File", type=str)

args = parser.parse_args()
infile = args.Infile
outfile = args.Outfile



ecclist = []
with open(infile,'r') as fa:
    for record in SeqIO.parse(fa, 'fasta'):
        repseq = record.seq*10
        eccref = SeqRecord(repseq, id=record.id)
        ecclist.append(eccref)

#outfile = '00_PseudoReference4eccDNAs.fa'
SeqIO.write(ecclist, outfile, "fasta")

