cat sample_list.txt | while read i; do


java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar SortSam \
      I= /ohta2/bianca.sacchi/eQTL_rumex_alignments/STAR/$i\Aligned.out.sam \
      O= /ohta2/bianca.sacchi/eQTL_rumex_alignments/Picard/tmp1/tmp1_$i.bam\
      SORT_ORDER=coordinate \
         VALIDATION_STRINGENCY=LENIENT


java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar AddOrReplaceReadGroups \
        I= /ohta2/bianca.sacchi/eQTL_rumex_alignments/Picard/tmp1/tmp1_$i.bam \
        O= /ohta2/bianca.sacchi/eQTL_rumex_alignments/Picard/AnalysisReady/AnalysisReady_$i.bam \
        VALIDATION_STRINGENCY=LENIENT \
        RGID=1$i \
        RGLB=lib1$i \
      RGPL=illumina$i \
      RGPU=unit1$i \
      RGSM=sample$i

done