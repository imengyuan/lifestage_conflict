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
