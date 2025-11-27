Specname=$1
mkdir Augustus_training
autoAugTrain.pl --trainingset=Augustus_training.gff --genome=Genome.sm.fasta --species=$Specname --workingdir=Augustus_training --optrounds=2 --verbose
