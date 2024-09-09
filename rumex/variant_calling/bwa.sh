bwa-mem2 index REF_LA.fa

ref=REF_LA.fa
parent_dir=/ohta2/Rumex/eQTL/DNA
out_dir=/ohta2/meng.yuan/rumex/eqtl/alignment
for i in $(less DNA.samples_30.txt)
do
bwa-mem2 mem -t 10 ${ref} ${parent_dir}/${i}_R1.fastq.gz ${parent_dir}/${i}_R2.fastq.gz | samtools view -S -b -o ${out_dir}/${i}_bwa.bam - 
done
