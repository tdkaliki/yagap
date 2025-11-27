ls -d "$PWD/"*.gtf | awk '{print $s "    minimap" NR "    True    0.5    False    False    False"}' > minimap_gtf_list.txt
