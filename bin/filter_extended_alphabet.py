#!/usr/bin/env python
from Bio import SeqIO
import sys
import re

ImputF=sys.argv[1]

output1=open("good_proteins.fasta", "w")
output2=open("bad_proteins.fasta", "w")

for record in SeqIO.parse(ImputF, "fasta"):
        aaseq=str(record.seq).replace("*", "")
        if len(re.sub(r"[GALMFWKQESPVICYHRNDTgalmfwkqesvvicyhrndt]", "", aaseq))>0:
                output2.write(">"+str(record.id)+"\n"+aaseq+"\n")
        else:
                output1.write(">"+str(record.id)+"\n"+aaseq+"\n")
output1.close()
output2.close()
