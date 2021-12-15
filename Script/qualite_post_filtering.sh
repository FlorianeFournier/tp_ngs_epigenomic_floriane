#Analayse qualité après filtering 

#!/bin/bash
#
# Compute basic quality metrics for ATAC-seq data
# 


# >>> change the value of the following variables

# General variables
workingDir=/home/rstudio/mydatalocal/tp_ngs_epigenomic_floriane
scriptDir=/home/rstudio/mydatalocal/tp_ngs_epigenomic_floriane/Script
outputDir=${workingDir}/ATACseq_quality

ID=2019_007_S7 # sample ID
bam_suffix=_Rshortmarked_duplicatedfiltered.bam #fin du nom du fichier


gtf=${workingDir}/Genoms_informations/Arabidopsis_thaliana.TAIR10.51.gtf # information sur le chromosome, gene/transcrit/transposon, coordonnées, gene_id, role du gene
selected_regions=${workingDir}/Genoms_informations/TAIR10_selectedRegions_Mt_Pt.bed
genome=${workingDir}/Genoms_informations/TAIR10_ChrLen.txt

# Variables for TSS enrichment
width=1000 #fenetre autour du TSS
flanks=100 #cote de la fenetre permet un calcul de la couverture moyen dans le genome

# Variables for insert size distribution
chrArabido=${workingDir}/Genoms_informations/TAIR10_ChrLen.bed
grep -v -E "Mt|Pt" ${chrArabido} > ${workingDir}/Genoms_informations/TAIR10_ChrLen_1-5.bed
chrArabido=${workingDir}/Genoms_informations/TAIR10_ChrLen_1-5.bed
#longueur du chromosome sans chloroplastes et sans mitochondries 


#////////////////////// Start of the script

mkdir -p ${outputDir}

bam=${workingDir}/Mapping/${ID}${bam_suffix}
samtools view ${bam} | head 



# ------------------------------------------------------------------------------------------------------------ #
# --------------------------- Compute TSS enrichment score based on TSS annotation -----sort -k1,1 -k2,2n in.bed > in.sorted.bed---------------------- #
# ------------------------------------------------------------------------------------------------------------ #

#1. Define genomic regions of interest
echo "-------------------------- Define genomic regions of interest"
#creation d'un fichier avec tous les intervals de 1000 autour de TSS
#définition des TSS enlever mitochondrie + chroloplaste 
#garder les genes codant pour des proteines 
#extraire l'index du premier caractère et du dernier caractère du gene, une fois que l'on a extrait le nom, on regarde le sens du gène
#uniq permet de garder une seule ligne par gène
grep -v "^[MtPt]" ${gtf} | awk '{ if ($3=="gene") print $0 }'  |\
grep "protein_coding" |\
awk ' BEGIN { FS=OFS="\t" } { split($9,a,";") ; match(a[1], /AT[0-9]G[0-9]+/) ; id=substr(a[1],RSTART,RLENGTH) ; if ($7=="+") print $1,$4,$4,id,$7 ; else print $1,$5,$5,id,$7 } ' |\
uniq | bedtools slop -i stdin -g ${genome} -b ${width} > ${outputDir}/tss_${width}.bed


bedtools intersect -u -a ${outputDir}/tss_${width}.bed -b ${selected_regions} > ${outputDir}/tmp.tss && mv ${outputDir}/tmp.tss ${outputDir}/tss_${width}.bed
echo `cat ${outputDir}/tss_${width}.bed | wc -l` "roi defined from" ${gtf}
#donne les intersections entre les TSS et les régions que l'on veut 

tssFile=${outputDir}/tss_${width}.bed
head ${tssFile}


#2. Compute TSS enrichment
echo "-------- Compute per-base coverage around TSS"
#donne la coordonnée dans la séquence et les reads qui match

sort -k1,1 -k2,2n ${tssFile} > ${tssFile/.bed/.test}
tssFile=${tssFile/.bed/.test}
bedtools coverage -a ${tssFile} -b ${bam} -d -sorted > ${outputDir}/${ID}_tss_depth.txt
#recentre les numeros de nt sur le TSS
awk -v w=${width} ' BEGIN { FS=OFS="\t" } { if ($5=="-") $6=(2*w)-$6+1 ; print $0 } ' ${outputDir}/${ID}_tss_depth.txt > ${outputDir}/${ID}_tss_depth.reoriented.txt
#awk permet de manipuler les tableaux, ici on découpe des colonnes et on les nomme
sort -n -k 6 ${outputDir}/${ID}_tss_depth.reoriented.txt > ${outputDir}/${ID}_tss_depth.sorted.txt

bedtools groupby -i ${outputDir}/${ID}_tss_depth.sorted.txt -g 6 -c 7 -o sum > ${outputDir}/${ID}_tss_depth_per_position.sorted.txt

norm_factor=`awk -v w=${width} -v f=${flanks} '{ if ($6<f || $6>(2*w-f)) sum+=$7 } END { print sum/(2*f) } ' ${outputDir}/${ID}_tss_depth.sorted.txt`
echo "Nf: " ${norm_factor}
awk -v w=${width} -v f=${flanks} '{ if ($1>f && $1<(2*w-f)) print $0 }' ${outputDir}/${ID}_tss_depth_per_position.sorted.txt | awk -v nf=${norm_factor} -v w=${width} 'BEGIN { OFS="\t" } { $1=$1-w ; $2=$2/nf ; print $0 }' > ${outputDir}/${ID}_tss_depth_per_position.normalized.txt
Rscript ${scriptDir}/plot_tss_enrich.R -f ${outputDir}/${ID}_tss_depth_per_position.normalized.txt -w ${width} -o ${outputDir}  




# ---------------------------------------------------------------------------------------- #
# ------------------------------- Insert size distribution ------------------------------- #
# ---------------------------------------------------------------------------------------- #

echo "-------- Compute insert size distribution"
samtools view -f 3 -F 16 -L ${chrArabido} -s 0.25 ${bam} | awk ' function abs(v){ return v < 0 ? -v : v } { print abs($9) } ' | sort -g | uniq -c | sort -k2 -g > ${outputDir}/${ID}_TLEN_1-5.txt
Rscript ${scriptDir}/plot_tlen.R -f ${outputDir}/${ID}_TLEN_1-5.txt -o ${outputDir}



# End of the script \\\\\\\\\\\\\\\\\\\\\\\\\\\\