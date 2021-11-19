#Construction du index avec le génome de référence 

#workdir=/home/rstudio/mydatalocal/tp_ngs_epigenomic_floriane/Genoms_informations/
#index_directory=/home/rstudio/mydatalocal/tp_ngs_epigenomic_floriane/Genoms_informations/index
#mkdir -p $index_directory
#cd $index_directory
#bowtie2-build -f ${workdir}Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz TAIR10


#Mapping

for fastq in Trim/*1_trimmed.fastq # for each sample
do
  suffixe=${fastq%%1_trimmed.fastq} # enlever suffixe
  prefix=${suffixe##"Trim/"} #enlever prefix et remplacer
  filedirprefix=Trim/${prefix}
  outputprefix=Mapping/${prefix}
  bowtie2 -x Genoms_informations/index/TAIR10 -1 ${filedirprefix}1_trimmed.fastq -2 ${filedirprefix}2_trimmed.fastq\
  -X 2000 --very-sensitive -p 6 | samtools sort -@ 6 --output-fmt bam -o ${outputprefix}short.bam

done

