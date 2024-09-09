# /genome

# new
STAR --runThreadN 16 --runMode genomeGenerate --genomeDir /ohta2/meng.yuan/ceratodon/genome/genome_R40 \
--genomeFastaFiles /ohta2/meng.yuan/ceratodon/genome/genome_R40/GCA_014871385.1_CpurpureusR40_1_0_genomic.fna --genomeSAindexNbases 13

STAR --runThreadN 16 --runMode genomeGenerate --genomeDir /ohta2/meng.yuan/ceratodon/genome/genome_GG1 \
--genomeFastaFiles /ohta2/meng.yuan/ceratodon/genome/genome_GG1/GCA_014871845.1_CpurpureusGG1_1_0_genomic.fna --genomeSAindexNbases 13


# map using STAR
for i in $(less /ohta2/meng.yuan/ceratodon/gametophyteRNA_M.txt)
do
STAR --genomeDir /ohta2/meng.yuan/ceratodon/genome/genome_R40 \
--readFilesCommand zcat \
--readFilesIn /ohta2/meng.yuan/ceratodon/gametophyte_clean/${i}_1.clean_paired.fq.gz \
/ohta2/meng.yuan/ceratodon/gametophyte_clean/${i}_2.clean_paired.fq.gz \
--twopassMode Basic \
--twopass1readsN -1 \
--outFileNamePrefix /ohta2/meng.yuan/ceratodon/STAR_gRNA_2genomes/pass2_$i \
--runThreadN 10
done

for i in $(less /ohta2/meng.yuan/ceratodon/gametophyteRNA_F.txt)
do
STAR --genomeDir /ohta2/meng.yuan/ceratodon/genome/genome_GG1 \
--readFilesCommand zcat \
--readFilesIn /ohta2/meng.yuan/ceratodon/gametophyte_clean/${i}_1.clean_paired.fq.gz \
/ohta2/meng.yuan/ceratodon/gametophyte_clean/${i}_2.clean_paired.fq.gz \
--twopassMode Basic \
--twopass1readsN -1 \
--outFileNamePrefix /ohta2/meng.yuan/ceratodon/STAR_gRNA_2genomes/pass2_$i \
--runThreadN 10
done

# run STAR for sporophyte RNA to separate genomes
for i in $(less sporophyte_25.txt)
do
STAR --genomeDir /ohta2/meng.yuan/ceratodon/genome/genome_R40 \
--readFilesCommand zcat \
--readFilesIn /ohta2/meng.yuan/ceratodon/sporophyte_clean2/${i}_clean.R1.fq.gz \
/ohta2/meng.yuan/ceratodon/sporophyte_clean2/${i}_clean.R2.fq.gz \
--twopassMode Basic \
--twopass1readsN -1 \
--outFileNamePrefix /ohta2/meng.yuan/ceratodon/STAR_sRNA_M/pass2_$i \
--runThreadN 20
done


for i in $(less sporophyte_25.txt)
do
STAR --genomeDir /ohta2/meng.yuan/ceratodon/genome/genome_GG1 \
--readFilesCommand zcat \
--readFilesIn /ohta2/meng.yuan/ceratodon/sporophyte_clean2/${i}_clean.R1.fq.gz \
/ohta2/meng.yuan/ceratodon/sporophyte_clean2/${i}_clean.R2.fq.gz \
--twopassMode Basic \
--twopass1readsN -1 \
--outFileNamePrefix /ohta2/meng.yuan/ceratodon/STAR_sRNA_F/pass2_$i \
--runThreadN 20
done



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



for i in $(less sporophyte_25.txt)
do
java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar SortSam \
          I=/ohta2/meng.yuan/ceratodon/STAR/STAR_sRNA_F/pass2_${i}\Aligned.out.sam \
          O=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_F/tmp1_${i}_f.bam \
          SORT_ORDER=coordinate \
          VALIDATION_STRINGENCY=LENIENT

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
java -jar /ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar SortSam \
          I=/ohta2/meng.yuan/ceratodon/STAR/STAR_sRNA_M/pass2_${i}\Aligned.out.sam \
          O=/ohta2/meng.yuan/ceratodon/BAM_AnalysisReady/AnalysisReady_sRNA_M/tmp1_${i}_m.bam \
          SORT_ORDER=coordinate \
          VALIDATION_STRINGENCY=LENIENT

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
