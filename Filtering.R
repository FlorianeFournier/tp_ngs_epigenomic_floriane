#enlever le genome non chromosomique
#reads qui n'ont pas mapper
#reads de mauvaise qualité de mapping
#régions blacklisté
#reads dupliqués

for mapfile in Mapping/*bam

do
  java -jar $PICARD MarkDuplicates \
    I=${mapfile} \
    O=${mapfile/".bam"/"marked_duplicated.bam"} \
    M=${mapfile/".bam"/"marked_dup_metics.txt"}

done


#enlever les régions filtré

grep -v -E "Mt|Pt" Genoms_informations/TAIR10_selectedRegions.bed > TAIR10_selectedRegions_Mt_Pt.bed #toutes les lignes sauf Pt et Mt donc sans ADN mito + chloro
mv *TAIR10* Genoms_informations/
  


for mapfile in Mapping/*duplicated.bam
do
  samtools view -b ${mapfile} -o ${mapfile/".bam"/"filtered.bam"} \
  -L Genoms_informations/TAIR10_selectedRegions_Mt_Pt.bed \
  -F 1024 -f 3 -q 30
done
