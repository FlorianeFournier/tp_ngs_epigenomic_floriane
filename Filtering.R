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
