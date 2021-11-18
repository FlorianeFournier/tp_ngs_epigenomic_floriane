#analyse qualité avec fastqc

#fastqc Data/* #analyse toutes les données 
#fastqc Data/2019_007_S7_R1.fastq #analyse juste pour une donnée afin de savoir comment ce sera nommée et aussi où il sera enregistré


#pour executer un script bash chemin du script
#mv ./Data/*fastqc* Fastqc


#multiqc .

#mv *multiqc_report* Data/
  
  

#contrôle qualité après trimming
  
fastqc Trim/*
mv .Trim/*fastqc* Fastqc_trim

multiqc .

mv *multiqc_report* Data/



  

