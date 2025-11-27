import sys

inputf=sys.argv[1]
outputf="RNA_hints.gff"

inf=open(inputf, "r")
outf=open(outputf, "w")
for line in inf:
    split1=line.split("\t")
    if len(split1)>8:
        if split1[2] == "exon":
            outf.write(line.strip()+";src=E\n")
outf.close()
inf.close()
