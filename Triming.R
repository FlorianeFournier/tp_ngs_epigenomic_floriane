#Trimming

/softwares/Trimmomatic-0.39/
Trimmomatic=/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar
java -jar $Trimmomatic
Nextera=/softwares/Trimmomatic-0.39/adapters/NexteraPE-PE.fa 


for f in Data/*1.fastq # on parcours les échantillons data

do
  n=${f%%1.fastq} # pour le nouveau nom on prend tout ce qui est avant 1.fastq
  prefixe=${n/"Data/"/"Trim/"} #change le prefixe
  java -jar $Trimmomatic PE -threads 6 -phred33 ${n}1.fastq  ${n}2.fastq \
  ${prefixe}1_trimmed.fastq ${prefixe}1_unpaired.fastq ${prefixe}2_trimmed.fastq \
  ${prefixe}2_unpaired.fastq ILLUMINACLIP:${Nextera}:2:30:10 \
  SLIDINGWINDOW:4:15 MINLEN:25

done



