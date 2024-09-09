# new
STAR --runThreadN 16 --runMode genomeGenerate \
--genomeDir /ohta2/meng.yuan/ceratodon/genome/genome_R40 \
--genomeFastaFiles /ohta2/meng.yuan/ceratodon/genome/genome_R40/GCA_014871385.1_CpurpureusR40_1_0_genomic.fna \
--genomeSAindexNbases 13

STAR --runThreadN 16 --runMode genomeGenerate \
--genomeDir /ohta2/meng.yuan/ceratodon/genome/genome_GG1 \
--genomeFastaFiles /ohta2/meng.yuan/ceratodon/genome/genome_GG1/GCA_014871845.1_CpurpureusGG1_1_0_genomic.fna \
--genomeSAindexNbases 13


# map male samples to Umasked genome, female samples to Vmasked genome
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
