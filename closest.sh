# bedtools closest


ASSOCIER des PICS aux GENES 
#gtf donne coordonnées, nom du gene, orientation pour comparaison, filtre le gtf avant

gtf=/home/rstudio/mydatalocal/Arabidocontratac/TAIR10/Arabidopsis_thaliana.TAIR10.51.gtf
gtf_filtered=${gtf/.gtf/.filtered.gtf}
PeakcallingDir=/home/rstudio/mydatalocal/tp_ngs_floriane/Peakcalling

grep -v "^[MtPt]" ${gtf} | awk '{ if ($3=="gene") print $0 }' |\
awk ' BEGIN { FS=OFS="\t" } { split($9,a,";") ; match(a[1], /AT[0-9]G[0-9]+/) ; id=substr(a[1],RSTART,RLENGTH) ; print $1,$4,$5,id,$7 }' |\
sort -k1,1 -k2,2n > ${gtf_filtered}

for f in ${PeakcallingDir}/*broadPeak
do
bedtools closest -a $f -b ${gtf_filtered} -D ref > ${f/_peaks.broadPeak/}.nearest.genes.txt
done
#D-ref pour savoir si overlap ou si plus loin