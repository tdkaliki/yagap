#needs mmseqs
mkdir Ref_Prot_DB
cd Ref_Prot_DB
cat ../good_proteins.fasta | mmseqs createdb stdin Ref_Prot_DB
mmseqs cluster Ref_Prot_DB Ref_Prot_clust_DB tmp/
mmseqs createsubdb Ref_Prot_clust_DB Ref_Prot_DB Ref_Prot_RepDb
mmseqs createsubdb Ref_Prot_clust_DB Ref_Prot_DB_h Ref_Prot_RepDb_h
mmseqs result2profile Ref_Prot_RepDb Ref_Prot_DB Ref_Prot_clust_DB Ref_Prot_ProfileDb
