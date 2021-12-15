
#regarde regions tres enrichies, pics utilisés pour faire trucs + fins, detection + fine par la suite

bamdir=/home/rstudio/mydatalocal/Arabidocontratac/Mapping
samtools index ${bamdir}/2019_006_S6.1mis.noDup.f3F1024.blacklisted.bam 
samtools index ${bamdir}/2020_374_S4.corrected.bam




#script PEAK CALLING \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


PeakcallingDir=/home/rstudio/mydatalocal/tp_ngs_floriane/Peakcalling
mkdir $PeakcallingDir
bam_suffix=.1mis.noDup.f3F1024.blacklisted.bam
bam_file=${bamdir}/2019_006_S6.1mis.noDup.f3F1024.blacklisted.bam 

IDbase="$(basename -- $bam_file)"
macs2 callpeak -f "BAM" -t ${bam_file} -n ${IDbase/$bam_suffix/} --outdir ${PeakcallingDir} -q 0.01 --nomodel --shift -25 --extsize 50 --keep-dup "all" -B --broad -g 10E7


PeakcallingDir=/home/rstudio/mydatalocal/tp_ngs_floriane/Peakcalling
mkdir $PeakcallingDir
bam_suffix=.1mis.noDup.f3F1024.blacklisted.bam
bam_file=${bamdir}/2020_374_S4.corrected.bam

IDbase="$(basename -- $bam_file)"
macs2 callpeak -f "BAM" -t ${bam_file} -n ${IDbase/$bam_suffix/} --outdir ${PeakcallingDir} -q 0.01 --nomodel --shift -25 --extsize 50 --keep-dup "all" -B --broad -g 10E7



