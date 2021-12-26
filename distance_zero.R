#création d'un fichier avec bedtool closest pour avoir la distance entre les gènes et le peak

gtf_filtered=/home/rstudio/mydatalocal/Arabidocontratac/TAIR10/Arabidopsis_thaliana.TAIR10.51.filtered.gtf

#gtf_filtered=${gtf/.gtf/.filtered.gtf}
#AnnotationsDir=/home/rstudio/mydatalocal/tp_ngs_floriane/Annotations

#grep -v "^[MtPt]" ${gtf} | awk '{ if ($3=="gene") print $0 }' |\
#awk ' BEGIN { FS=OFS="\t" } { split($9,a,";") ; match(a[1], /AT[0-9]G[0-9]+/) ; id=substr(a[1],RSTART,RLENGTH) ; print $1,$4,$5,id,$7 }' |\
#sort -k1,1 -k2,2n > ${gtf_filtered}

for f in ${AnnotationsDir}/*quiescentcells.unique.common.peaks.treated.txt
do
bedtools closest -a $f -b ${gtf_filtered} -D a > ${f/_peaks.broadPeak/}.nearest.genes.txt
done
#a permet de préciser si le pic est avant ou après 


#sélection des peaks où la distance gene peaks est de 0

data=read.table(file="Annotations/quiescentcells.unique.common.peaks.treated.txt.nearest.genes.txt")
nrow(data)
nrow(data[data$V11==0,])
datacommonpeak=subset(data,data$V11==0)
nrow(datacommonpeak)
View(datacommonpeak)
write.table(datacommonpeak,file="Annotations/quiescentcells.unique.common.zero.txt",row.names=FALSE,col.names=FALSE,sep="\t",quote=FALSE)