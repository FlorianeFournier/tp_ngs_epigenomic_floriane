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

