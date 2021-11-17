#telechargement fichiers
  #fichiers nouveaux 
wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2019_007_S7_R1.fastq.gz
wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2019_007_S7_R2.fastq.gz
wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2020_378_S8_R1.fastq.gz
wget --user='tp_ngs' --password='Arabido2021!' https://flower.ens-lyon.fr/tp_ngs/Data/2020_378_S8_R2.fastq.gz



  #fichiers précédente plublication
fastq-dump --split-files SRR4000472


#mettre dans data
mv 2019_007_S7_R1.fastq.gz Data/  #un par un 
mv *fastq* Data/   #tous ceux qui ont fastq dans leur nom 