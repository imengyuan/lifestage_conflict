
for i in $(less /ohta2/meng.yuan/ceratodon/gametophyteRNA/gametophyte.txt)
do
java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar SortSam \
          I=/ohta2/meng.yuan/ceratodon/STAR_gRNA_2genomes/pass2_$i\Aligned.out.sam \
          O=/ohta2/meng.yuan/ceratodon/AnalysisReady_gRNA_2genomes/tmp1_$i.bam \
          SORT_ORDER=coordinate \
          VALIDATION_STRINGENCY=LENIENT

java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar AddOrReplaceReadGroups \
  I=/ohta2/meng.yuan/ceratodon/AnalysisReady_gRNA_2genomes/tmp1_$i.bam \
  O=/ohta2/meng.yuan/ceratodon/AnalysisReady_gRNA_2genomes/AnalysisReady_$i.bam \
          VALIDATION_STRINGENCY=LENIENT \
        RGID=1$i \
       RGLB=lib1$i \
       RGPL=illumina$i \
       RGPU=unit1$i \
       RGSM=sample$i
done

rerun the above script, troubleshoot, maybe move to niagara

## SET TMP FOLDER TO AVOID 'No space left on device' ERROR
# sh ./scripts/g.bam_processing_2genomes.sh
# Caused by: java.nio.file.FileSystemException: /tmp/meng.yuan/sortingcollection.133122573801530319.tmp: No space left on device
# none finished

# sh ./scripts/s.bam_processing_genomeF.sh
# finished

# sh ./scripts/s.bam_processing_genomeM.sh
# finished
# only some finished
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar SortSam \



for i in $(less /ohta2/meng.yuan/ceratodon/gametophyteRNA/gametophyteRNA_M.txt)
do
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar AddOrReplaceReadGroups \
  I=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_gRNA_2genomes/tmp1_${i}.bam \
  O=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_gRNA_2genomes/AnalysisReady_${i}_m.bam \
          VALIDATION_STRINGENCY=LENIENT \
        RGID=1$i \
       RGLB=lib1$i \
       RGPL=illumina$i \
       RGPU=unit1$i \
       RGSM=sample$i
done


for i in $(less /ohta2/meng.yuan/ceratodon/gametophyteRNA/gametophyteRNA_F.txt)
do
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar AddOrReplaceReadGroups \
  I=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_gRNA_2genomes/tmp1_${i}.bam \
  O=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_gRNA_2genomes/AnalysisReady_${i}_f.bam \
          VALIDATION_STRINGENCY=LENIENT \
        RGID=1$i \
       RGLB=lib1$i \
       RGPL=illumina$i \
       RGPU=unit1$i \
       RGSM=sample$i
done


# rerun the second step
AnalysisReady_sRNA_2genomes too...

for i in $(less /ohta2/meng.yuan/ceratodon/sporophyte/sporophyte_25.txt)
do
# java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar SortSam \
#           I=/ohta2/meng.yuan/ceratodon/STAR/STAR_sRNA_F/pass2_${i}\Aligned.out.sam \
#           O=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_F/tmp1_${i}_f.bam \
#           SORT_ORDER=coordinate \
#           VALIDATION_STRINGENCY=LENIENT

java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar AddOrReplaceReadGroups \
  I=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_F/tmp1_${i}_f.bam \
  O=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_F/AnalysisReady_${i}_f.bam \
          VALIDATION_STRINGENCY=LENIENT \
        RGID=1${i} \
       RGLB=lib1${i} \
       RGPL=illumina${i} \
       RGPU=unit1${i} \
       RGSM=sample${i}
done


for i in $(less /ohta2/meng.yuan/ceratodon/sporophyte/sporophyte_25.txt)
do
# java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar SortSam \
#           I=/ohta2/meng.yuan/ceratodon/STAR/STAR_sRNA_M/pass2_${i}\Aligned.out.sam \
#           O=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_M/tmp1_${i}_m.bam \
#           SORT_ORDER=coordinate \
#           VALIDATION_STRINGENCY=LENIENT

java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar AddOrReplaceReadGroups \
  I=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_M/tmp1_${i}_m.bam \
  O=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_M/AnalysisReady_${i}_m.bam \
          VALIDATION_STRINGENCY=LENIENT \
        RGID=1${i} \
       RGLB=lib1${i} \
       RGPL=illumina${i} \
       RGPU=unit1${i} \
       RGSM=sample${i}
done


sRNA_F_2genomes_bam.sh



# run featureCount


featureCounts -F GTF -p -T 20 -t mRNA -g Parent -a /ohta2/meng.yuan/ceratodon/genome/R40_GG1U_combined.gff -o /ohta2/meng.yuan/ceratodon/featureCount/readcnts_ceratodon_mRNA_gene_testAug23.txt \
../BAM_AnalysisReady/AnalysisReady_gRNA_2genomes/AnalysisReady_SRR8268984_m.bam \
../BAM_AnalysisReady/AnalysisReady_gRNA_2genomes/AnalysisReady_SRR8268993_f.bam \
../BAM_AnalysisReady/AnalysisReady_sRNA_F/AnalysisReady_JDBN_RNAseq_B150_B190_G_3_Plate1_AAGTCCAA_Ceratodon_purpureus_I1044_L3_f.bam \
../BAM_AnalysisReady/AnalysisReady_sRNA_M/AnalysisReady_JDBN_RNAseq_B150_B190_G_3_Plate1_AAGTCCAA_Ceratodon_purpureus_I1044_L3_m.bam 


# 分三次
/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_gRNA_2genomes/
/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_F
/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_M

 >> s_m.out 2>&1








