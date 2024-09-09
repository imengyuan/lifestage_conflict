bedtools maskfasta -fi /ohta2/meng.yuan/ceratodon/genome/R40_GG1U_combined.fa \
-bed U.bed -fo /ohta2/meng.yuan/ceratodon/genome/R40_GG1U_Umasked.fa

bedtools maskfasta -fi /ohta2/meng.yuan/ceratodon/genome/R40_GG1U_combined.fa \
-bed V.bed -fo /ohta2/meng.yuan/ceratodon/genome/R40_GG1U_Vmasked.fa

bwa-mem2 index R40_GG1U_Umasked.fa
bwa-mem2 index R40_GG1U_Vmasked.fa

# for male samples 
ref=/ohta2/meng.yuan/ceratodon/genome/R40_GG1U_Umasked.fa
parent_dir=/ohta2/meng.yuan/ceratodon/gametophyteDNA_clean/
out_dir=/ohta2/meng.yuan/ceratodon/gametophyteDNA_bwa
for i in $(less gametophyteDNA_M.txt)
do
bwa-mem2 mem -t 10 ${ref} ${parent_dir}/${i}_1.clean_paired.fq.gz ${parent_dir}/${i}_2.clean_paired.fq.gz | samtools view -S -b -o ${out_dir}/${i}_bwa.bam - 
done

# for female samples
ref=/ohta2/meng.yuan/ceratodon/genome/R40_GG1U_Vmasked.fa
parent_dir=/ohta2/meng.yuan/ceratodon/gametophyteDNA_clean/
out_dir=/ohta2/meng.yuan/ceratodon/gametophyteDNA_bwa
for i in $(less gametophyteDNA_F.txt)
do
bwa-mem2 mem -t 10 ${ref} ${parent_dir}/${i}_1.clean_paired.fq.gz ${parent_dir}/${i}_2.clean_paired.fq.gz | samtools view -S -b -o ${out_dir}/${i}_bwa.bam - 
done


