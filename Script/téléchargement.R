#telechargement fichiers
  #fichiers nouveaux 
wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2019_007_S7_R1.fastq.gz
wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2019_007_S7_R2.fastq.gz
wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2020_378_S8_R1.fastq.gz
wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2020_378_S8_R2.fastq.gz
wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Supporting_files/TAIR10_selectedRegions.bed



  #fichiers précédente plublication
fastq-dump --split-files SRR4000472


#mettre dans data
mv 2019_007_S7_R1.fastq.gz Data/  #un par un 
mv *fastq* Data/   #tous ceux qui ont fastq dans leur nom 
  
#téléchargement standard files
wget http://ftp.ebi.ac.uk/ensemblgenomes/pub/release-51/plants/fasta/arabidopsis_thaliana/dna/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
wget http://ftp.ebi.ac.uk/ensemblgenomes/pub/release-51/plants/gtf/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.51.gtf.gz

#mette dans genoms informations
mv *thaliana* Genoms_informations/
mv *selectedRegions* Genoms_informations/
  
  
#déziper un dossier
gunzip Data/2019_007_S7_R1.fastq.gz
gunzip Data/2019_007_S7_R2.fastq.gz
gunzip Data/2020_378_S8_R1.fastq.gz
gunzip Data/2020_378_S8_R2.fastq.gz



