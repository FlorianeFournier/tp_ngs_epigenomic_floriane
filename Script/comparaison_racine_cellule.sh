#regarder où sont localisé les gènes sur le genome en comparant racine et cellules quiescente

annotationsDir=/home/rstudio/mydatalocal/tp_ngs_floriane/Annotations
workingDir=/home/rstudio/mydatalocal/tp_ngs_floriane/Peakcalling
mkdir -p $annotationsDir

#pour 006 quiescent/racine 374
W006=2019_006_S6_R_peaks.broadPeak
racine=2020_374_S4.corrected.bam_peak.broadPeak
bedtools intersect -v -a ${workingDir}/$W006 -b ${workingDir}/$racine > ${annotationsDir}/${W006/.nearest.genes.txt/}_${racine/.nearest.genes.txt/}_difference.txt



#pour 007 quiescent/racine 374
W006=2019_007_S7_R_peaks.broadPeak
racine=2020_374_S4.corrected.bam_peak.broadPeak
bedtools intersect -v -a ${workingDir}/$W006 -b ${workingDir}/$racine > ${annotationsDir}/${W006/.nearest.genes.txt/}_${racine/.nearest.genes.txt/}_difference.txt



#pour 372 quiescent/racine 374
W006=2020_372_S2_R_peaks.broadPeak
racine=2020_374_S4.corrected.bam_peak.broadPeak
bedtools intersect -v -a ${workingDir}/$W006 -b ${workingDir}/$racine > ${annotationsDir}/${W006/.nearest.genes.txt/}_${racine/.nearest.genes.txt/}_difference.txt



#peak commun aux 3 échantillons

sample1=${annotationsDir}/2019_006_S6_R_2020_374_S4.corrected.bam_difference.txt
sample2=${annotationsDir}/2019_007_S7_R_2020_374_S4.corrected.bam_difference.txt
sample3=${annotationsDir}/2020_372_S2_R_2020_374_S4.corrected.bam_difference.txt
touch ${annotationsDir}/quiescentcells.common.peaks.txt
cat ${sample1} >> ${annotationsDir}/quiescentcells.common.peaks.txt
cat ${sample2} >> ${annotationsDir}/quiescentcells.common.peaks.txt
cat ${sample3} >> ${annotationsDir}/quiescentcells.common.peaks.txt
sort -k1,1 -k2,2n ${annotationsDir}/quiescentcells.common.peaks.txt > ${annotationsDir}/quiescentcells.common.peaks.sorted.txt
bedtools merge -i ${annotationsDir}/quiescentcells.common.peaks.sorted.txt -c 4 -o "collapse","count_distinct"> ${annotationsDir}/quiescentcells.unique.common.peaks.txt
