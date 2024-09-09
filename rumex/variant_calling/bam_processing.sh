#!/bin/bash

#from: https://github.com/jkreinz/Amaranthus-tuberculatus-PNAS2019/blob/master/aligning_bamprocessing/bam_processing.sh
#install Picard: https://broadinstitute.github.io/picard/ , https://github.com/broadinstitute/picard/releases/tag/2.8.1

prefix=/ohta2/bianca.sacchi/eQTL_rumex_variantcalling/sorted_bams
picard=/ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar
names=/ohta2/meng.yuan/rumex/eqtl/DNA.samples_full.txt
ref=/ohta1/bianca.sacchi/rhast_remap/genome/REF_LA.fa
out=/ohta2/bianca.sacchi/eQTL_rumex_variantcalling

while read sample
do

###################
#PROCESSESING BAMS
###################
#note, from GATK: "begin by mapping the sequence reads to the reference genome to produce a file in SAM/BAM format sorted by coordinate. Next, we mark duplicates to mitigate biases introduced by data generation steps such as PCR amplification. Finally, we recalibrate the base quality scores, because the variant calling algorithms rely heavily on the quality scores assigned to the individual base calls in each sequence read."
#sambamba version 0.6.6

#Sort and index

samtools sort -o ${out}/${sample}.sorted.bam ${prefix}/${sample}_bwa.bam >> ${out}/sort1.out 2>> ${out}/sort2.out

#gzip ${prefix}/${sample}.bam

java -jar $picard AddOrReplaceReadGroups \
        INPUT=${prefix}/${sample}.sorted.bam \
        OUTPUT=${out}/${sample}.sorted.rg.bam \
        RGLB=eqtlRumex \
        RGPL=Illumina \
        RGPU=unit1 \
        RGSM=${sample} \
        >> ${out}/RG.out 2>> ${out}/RG.err

java  -jar $picard BuildBamIndex \
      I=${out}/${sample}.sorted.rg.bam

#Splits Cigars - RNA only
#java -Djava.io.tmpdir=~/tmp -jar $gatk -T SplitNCigarReads -R ${ref} -I ${prefix}/${sample}.sorted.rg.bam -o ${prefix}/${sample}.sorted.split.bam -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS >${sample}.sorted.split.out 2>${sample}.sorted.split.err

#Mark Duplicates & Index - this is the generalized command
java -jar $picard MarkDuplicates \
    INPUT=${out}/${sample}.sorted.rg.bam \
    OUTPUT=${out}/${sample}.sorted.rg.dedup.bam \
    METRICS_FILE=${out}/${sample}.metrics.txt

done < $names