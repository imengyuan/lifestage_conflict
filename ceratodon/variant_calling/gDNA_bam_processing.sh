# same for female samples
for i in $(less gametophyteDNA_M.txt)
do
out=gDNA_BAM
picard=/ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar

# after getting bwa.bam, sort bam
samtools sort -O bam -o ${out}/${i}.sorted.bam gametophyteDNA_bwa/${i}_bwa.bam >> sort1.out 2>&1

# add read group
java -jar $picard AddOrReplaceReadGroups \
       INPUT=${out}/${i}.sorted.bam \
       OUTPUT=${out}/${i}.sorted.rg.bam \
       RGID=${i}_id \
       RGLB=ceratodon \
       RGPL=Illumina \
       RGPU=unit1 \
       RGSM=${i} \
       >> RG.out 2>&1

# index new bam samtools/picard
java -jar $picard BuildBamIndex \
      I=${out}/${i}.sorted.rg.bam
      
#Mark Duplicates & Index - this is the generalized command
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar $picard MarkDuplicates \
       I=${out}/${i}.sorted.rg.bam\
       O=${out}/${i}.sorted.rg.dedup.bam \
       M=${out}/${i}.metrics.txt \
       CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
       >> ${i}.dedup.out 2>&1

done

rm *.sorted.bam
rm *.sorted.rg.bam
rm *.sorted.rg.bai