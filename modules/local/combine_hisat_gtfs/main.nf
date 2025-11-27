ls -d "$PWD/"*.gtf | awk '{print $s "    stringtie" NR "    True    0.5    False    False    False"}' > hisat_gtf_list.txt

