#enlever le genome non chromosomique
#reads qui n'ont pas mapper
#reads de mauvaise qualité de mapping
#régions blacklisté
#reads dupliqués

for mapfile in Mapping/*bam

do
  java -jar $PICARD MarkDuplicates \ #pour marquer les duplicats de PCR afin de pouvoir les enlever
    I=${mapfile} \
    O=${mapfile/".bam"/"marked_duplicated.bam"} \
    M=${mapfile/".bam"/"marked_dup_metics.txt"}

done


#enlever les régions filtré

grep -v -E "Mt|Pt" Genoms_informations/TAIR10_selectedRegions.bed > TAIR10_selectedRegions_Mt_Pt.bed #toutes les lignes sauf Pt et Mt donc sans ADN mito + chloro
mv *TAIR10* Genoms_informations/ #enlever les régions aux genome mitochondrial et chloroplastique : grep pour chercher les chaines de caractère dans un fichier
  


for mapfile in Mapping/*duplicated.bam
do
  samtools view -b ${mapfile} -o ${mapfile/".bam"/"filtered.bam"} \ #utilise samtools view pour ouvrir les fichier bam et on utilise -L pour afficher les reads mapper que dans des régions que l'on a spécifié
  -L Genoms_informations/TAIR10_selectedRegions_Mt_Pt.bed \
  -F 1024 -f 3 -q 30 #on filtre les flags dans les séquences avec F et f : F pour exclure 1024: duplicat de PCR q pour la qualité et f : inclure 3: reads perré 
done
