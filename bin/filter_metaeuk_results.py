import re
import sys

inputf=sys.argv[1]
inf=open(inputf, "r")
outf=open("protein_hints.gff", "w")
outf2=open("metaeuk_for_busco.gff", "w")
outf3=open("metaeuk_evm.gff", "w")

outf4=open("metaeuk_cds.gff", "w")
outf2.write("##gff-version 3\n")
genedict={}
mRNAdict={}
exondict={}
cdsdict={}
cdsdict2={}
evmdict={}

countdict={}
genecount=0
for line in inf:
        line=line.strip()
        target0=line.split("\t")[8]
        target1=target0.split(";")[0]
        line=re.sub("\tTarget_ID=.+;TCS_ID=", "\tID=", line)
        split1=line.split("\t")
        id0=split1[8]
        id1=id0.split(";")[0]
        id1=id1.replace("_mRNA", "")
        id1=id1.replace("_exon", "")
        id1=id1.replace("_CDS", "")
        id1=id1.split("=")[1]
        id0=id0.replace("|", "_")
        id2=id1.replace("|", "_")
        id2=re.sub("_-$", "", id2)
        id2=re.sub("_\+$", "", id2)

        if split1[1]=="gene":
                genecount+=1
                trancount=0
                genedict[id1]=split1[0]+"\t"+split1[2]+"\t"+split1[1]+"\t"+split1[3]+"\t"+split1[4]+"\t.\t"+split1[6]+"\t"+split1[7]+"\tID="+id2+".g"+str(genecount)+"\n"
        if split1[1]=="mRNA":
                trancount+=1
                mRNAdict[id1]=split1[0]+"\t"+split1[2]+"\ttranscript\t"+split1[3]+"\t"+split1[4]+"\t.\t"+split1[6]+"\t"+split1[7]+"\tID="+id2+".g"+str(genecount)+".t"+str(trancount)+";Parent="+id2+".g"+str(genecount)+"\n"
        if split1[1]=="exon":
                exon1=split1[0]+"\t"+split1[2]+"\texon\t"+split1[3]+"\t"+split1[4]+"\t.\t"+split1[6]+"\t"+split1[7]+"\tID="+id2+".g"+str(genecount)+".t"+str(trancount)+".exon;Parent="+id2+".g"+str(genecount)+".t"+str(trancount)+"\n"
                exondict[id1]=exondict.get(id1, "")+exon1
                countdict[id1]=countdict.get(id1, 0)+1
        if split1[1]=="CDS":
                cds1=split1[0]+"\t"+split1[2]+"\tCDSpart\t"+split1[3]+"\t"+split1[4]+"\t"+split1[5]+"\t"+split1[6]+"\t"+split1[7]+"\tID="+id2+".g"+str(genecount)+".t"+str(trancount)+".cds;Parent="+id2+".g"+str(genecount)+".t"+str(trancount)+"\n"
                cds2=split1[0]+"\t"+split1[2]+"\tCDS\t"+split1[3]+"\t"+split1[4]+"\t"+split1[5]+"\t"+split1[6]+"\t"+split1[7]+"\tID="+id2+".g"+str(genecount)+".t"+str(trancount)+".cds;Parent="+id2+".g"+str(genecount)+".t"+str(trancount)+"\n"
                evm1=split1[0]+"\tmetaeuk-proteins.fasta\tnucleotide_to_protein_match\t"+split1[3]+"\t"+split1[4]+"\t"+split1[5]+"\t"+split1[6]+"\t"+split1[7]+"\tID=match.metaeuk.proteins.fasta."+str(genecount)+";"+target1+"\n"
                cdsdict2[id1]=cdsdict2.get(id1, "")+cds2
                cdsdict[id1]=cdsdict.get(id1, "")+cds1.strip()+";src=P\n"
                evmdict[id1]=evmdict.get(id1, "")+evm1
for key in genedict.keys():
        outf4.write(cdsdict2[key])
        if countdict[key]>1:
                outf2.write(genedict[key]+mRNAdict[key]+exondict[key]+cdsdict2[key])
                outf.write(cdsdict[key])
                outf3.write(evmdict[key]+"\n")
