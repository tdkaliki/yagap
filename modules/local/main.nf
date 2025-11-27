gmap_build -D gmapdb -d Genome ../../Genome.fasta
gmap -D gmapdb -d Genome -f 3 -n 0 -x 50 -t 10 -B 4 --gff3-add-separators=0 P_utriculus_All_Samples.Trinity.fasta > Trinity.gff3
ls -d "$PWD/"Trinity.gff3 | awk '{print $s "    trinity False   -0.5    False   False   False"}' > trinity_for_mikado.txt
