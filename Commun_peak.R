#determination des peaks commun à plusieurs

data=read.table(file="Annotations/quiescentcells.unique.common.peaks.txt")
nrow(data)
nrow(data[data$V5>=2,])
datacommonpeak=subset(data,data$V5>=2)
nrow(datacommonpeak)
View(datacommonpeak)
write.table(datacommonpeak,file="Annotations/quiescentcells.unique.common.peaks.treated.txt",row.names=FALSE,col.names=FALSE,sep="\t",quote=FALSE)